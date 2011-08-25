//
//  AnimationView.m
//  PrimeNumbers
//
//  Created by Jayant Sai on 10/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
// How to pause the animation of a layer tree. http://developer.apple.com/library/ios/#qa/qa2009/qa1673.html

#import "AnimationView.h"
#import <QuartzCore/QuartzCore.h>
#import <time.h>

#import "PrimeNumberOperation.h"

#import "StarFieldConfig.h"
#import "RainConfig.h"
#import "PrintConfig.h"
#import "ConfigViewController.h"


static UIFont *kStarFieldLabelFont;



#pragma mark Class extension


@interface AnimationView ()

- (void)configView;

#pragma mark operation
@property (nonatomic, retain) NSOperationQueue *queue;

@property (assign) NSUInteger startNum;

#pragma mark animation
@property (nonatomic, retain) NSMutableSet *labelPool;
@property (nonatomic, retain) NSMutableDictionary *animatingDict;

- (void)createNumberLayer:(NSNumber *)number;

#pragma mark state
@property (nonatomic, readwrite, assign) BOOL animating;
@property (nonatomic, readwrite, assign) BOOL paused;

@end


#pragma mark -

@implementation AnimationView

@synthesize queue, startNum;
@synthesize labelPool, animatingDict;
@synthesize config, speed, animating, paused;


#pragma mark -
#pragma mark overrides


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configView];
    }
    
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self configView];
}


- (void)dealloc {
    [self.queue cancelAllOperations];    
    self.queue = nil;
    
    self.config = nil;
    
    self.labelPool = nil;
    self.animatingDict = nil;
    
    [super dealloc];
}


#pragma mark private methods


- (void)configView {
    //initialize static
    kStarFieldLabelFont = [UIFont fontWithName:@"Verdana" size:13.0];
    
    //init values
    self.startNum = 2;
    self.clipsToBounds = YES;
    
    self.labelPool = [NSMutableSet setWithCapacity:100];
    self.animatingDict = [NSMutableDictionary dictionaryWithCapacity:100];
    
    NSOperationQueue *q = [[NSOperationQueue alloc] init];
    q.maxConcurrentOperationCount = 1;
    self.queue = q;
    [q release];
    
    srand(time(NULL));
}


#pragma mark methods


- (void)start {
    [self stop];
    
    PrimeNumberOperation *op = [[PrimeNumberOperation alloc] initWithTarget:self action:@selector(createNumberLayer:)];
    op.startNum = self.startNum;
    [self.queue addOperation:op];
    [op release];
    
    self.animating = YES;
    self.paused = NO;
}


- (void)stop {
    [self.queue cancelAllOperations];
    
    self.animating = NO;
}


- (void)pause {
    [self.queue cancelAllOperations];
    
    self.paused = YES;
    
    for (NSString *name in self.animatingDict) {
        CALayer *lyr = [self.animatingDict valueForKey:name];
        CFTimeInterval pausedTime = [lyr convertTime:CACurrentMediaTime() fromLayer:nil];
        lyr.speed = 0.0;
        lyr.timeOffset = pausedTime;
    }
}


- (void)resume {
    for (NSString *name in self.animatingDict) {
        CALayer *lyr = [self.animatingDict valueForKey:name];
        
        CFTimeInterval pausedTime = [lyr timeOffset];
        lyr.speed = 1.0;
        lyr.timeOffset = 0.0;
        lyr.beginTime = 0.0;
        
        CFTimeInterval timeSincePause = [lyr convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
        lyr.beginTime = timeSincePause;
    }
    
    self.paused = NO;
    
    if (self.animating) {
        [self start];
    }
}


- (void)reset {
    [self stop];
    
    self.startNum = 2;
    
    if ([(id)self.config respondsToSelector:@selector(reset)]) {
        [self.config reset];
    }
}


#pragma mark layer methods


/* Dequeue layer from layer pool */
- (CALayer *)dequeueLayer {
    CALayer *lyr = [self.labelPool anyObject];
    if (lyr) {
        [lyr retain];
        [self.labelPool removeObject:lyr];
    }
    else {
        lyr = [[CALayer layer] retain];
        lyr.rasterizationScale = YES;
    }
    
    return [lyr autorelease];
}


/* Add layer to layer pool */
- (void)enqueueLayer:(CALayer *)lyr {
    [self.labelPool addObject:lyr];
}


/* Create layer, configure and add to view */
- (void)createNumberLayer:(NSNumber *)number {
    //store prime as starting number incase animation stopped/paused
    self.startNum = [number unsignedIntegerValue] + 1;
    NSString *str = [NSString stringWithFormat:@"%@", number];
    NSString *name = [NSString stringWithFormat:@"%@_%u", number, [[NSDate date] timeIntervalSinceReferenceDate]];
    
    //get new layer
    CALayer *lyr = [self dequeueLayer];
    lyr.name = name;

    //size layer based on number string
    CGSize size = [str sizeWithFont:kStarFieldLabelFont];
    lyr.frame = CGRectMake(0.0, 0.0, size.width, size.height);
    
    //draw string to context
    UIGraphicsBeginImageContext(size);
    CGContextClearRect(UIGraphicsGetCurrentContext(), lyr.frame);
    
    CGContextSetRGBFillColor(UIGraphicsGetCurrentContext(), 1.0, 1.0, 1.0, 1.0);
    [str drawAtPoint:CGPointZero withFont:kStarFieldLabelFont];

    lyr.contents = (id)UIGraphicsGetImageFromCurrentImageContext().CGImage;
    
    UIGraphicsEndImageContext();
    
    //add layer animation from Config
    CAAnimation *anim = [self.config animationForLayer:lyr ofSize:(CGSize)size];
    [anim setValue:name forKey:@"name"];
    anim.delegate = self;
    anim.duration = self.speed; //MAX(3.0, rand() % self.speed);
    [lyr addAnimation:anim forKey:@"Animation"];

    //add to dictionaries
    [self.animatingDict setValue:lyr forKey:name];
    
    if (!self.paused) {
        [self.layer addSublayer:lyr];
    }
}


#pragma mark CAAnimation delegate


/* On animation end, remove layer and put in pool */
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    NSString *name = [theAnimation valueForKey:@"name"];
    CALayer *lyr = [self.animatingDict valueForKey:name];
    
    [lyr retain];
    
    [lyr removeFromSuperlayer];
    [self.animatingDict removeObjectForKey:name];
    
    [self enqueueLayer:lyr];
    [lyr release];
}


@end
