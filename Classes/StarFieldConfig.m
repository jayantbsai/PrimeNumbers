//
//  StarFieldConfig.m
//  PrimeNumbers
//
//  Created by Jayant Sai on 10/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "StarFieldConfig.h"
#import <time.h>


@interface StarFieldConfig ()

@property (nonatomic, assign) UIView *view;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGSize viewSize;

@end



@implementation StarFieldConfig

@synthesize view;
@synthesize startPoint, viewSize;


#pragma mark Config


- (id)initWithView:(UIView *)v {
    if (self = [super init]) {
        self.view = v;
        self.viewSize = v.bounds.size;
        [self reset];
        
        UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandler:)];
        recognizer.minimumNumberOfTouches = 1;
        recognizer.maximumNumberOfTouches = 1;
        [v addGestureRecognizer:recognizer];
        [recognizer release];
        
        srand(time(NULL));
    }
    
    return self;
}


- (void)reset {
    self.startPoint = self.view.center;
}


- (CAAnimation *)animationForLayer:(CALayer *)layer ofSize:(CGSize)size {
    CABasicAnimation *boundsAnim = [CABasicAnimation animationWithKeyPath:@"bounds"];
    boundsAnim.fromValue = [NSValue valueWithCGRect:CGRectMake(0.0, 0.0, 1.0, 1.0)];
    boundsAnim.toValue = [NSValue valueWithCGRect:CGRectMake(0.0, 0.0, size.width * 2.0, size.height * 2.0)];
    
    CABasicAnimation *positionAnim = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnim.fromValue = [NSValue valueWithCGPoint:self.startPoint];
    int angle = rand() % 360;
    positionAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(self.startPoint.x + self.viewSize.width * cosf(angle), 
                                                                 self.startPoint.y + self.viewSize.height * sinf(angle))];
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.autoreverses = NO;
    animGroup.removedOnCompletion = NO;
    animGroup.fillMode = kCAFillModeForwards;
    animGroup.animations = [NSArray arrayWithObjects:boundsAnim, positionAnim, nil];
    
    return animGroup;
}


#pragma mark UIPanGestureRecognizer


- (void)panGestureHandler:(UIPanGestureRecognizer *)recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
            self.startPoint = [recognizer locationOfTouch:0 inView:self.view];
            break;
        default:
            break;
    }
}


@end
