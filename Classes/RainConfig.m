//
//  RainConfig.m
//  PrimeNumbers
//
//  Created by Jayant Sai on 10/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RainConfig.h"
#import <UIKit/UIKit.h>
#import <time.h>

#define kRainConfigDelta 100.0


@interface RainConfig ()

@property (nonatomic, assign) UIView *view;
@property (nonatomic, assign) CGSize viewSize;

@property (nonatomic, assign) CGFloat delta;

@end



@implementation RainConfig

@synthesize view, viewSize;
@synthesize delta;


#pragma mark -
#pragma mark Config


- (id)initWithView:(UIView *)v {
    if (self = [super init]) {
        self.view = v;
        self.viewSize = v.bounds.size;
        [self reset];
        
        UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightGestureRecognizerHandler:)];
        rightRecognizer.numberOfTouchesRequired = 1;
        rightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        [v addGestureRecognizer:rightRecognizer];
        [rightRecognizer release];        
        
        UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftGestureRecognizerHandler:)];
        leftRecognizer.numberOfTouchesRequired = 1;
        leftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        [v addGestureRecognizer:leftRecognizer];
        [leftRecognizer release];  
        
        srand(time(NULL));
    }
    
    return self;
}


- (void)reset {
    self.delta = 0.0;
}


- (CAAnimation *)animationForLayer:(CALayer *)layer ofSize:(CGSize)size {
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
    anim.autoreverses = NO;
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    
    int r = rand();
    int w = (int) self.viewSize.width;
    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(r % w, 0.0)];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(r % w + self.delta, self.viewSize.height)];
    
    return anim;
}


#pragma mark -
#pragma mark UISwipeGestureRecognizer


- (void)rightGestureRecognizerHandler:(UISwipeGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        self.delta += kRainConfigDelta;
    }
}


- (void)leftGestureRecognizerHandler:(UISwipeGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        self.delta -= kRainConfigDelta;
    }
}


@end
