//
//  AnimationView.h
//  PrimeNumbers
//
//  Created by Jayant Sai on 10/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


/* Animation configuration */
@protocol Config


/* Init config. Add any gesture recognizers to view */
- (id)initWithView:(UIView *)view;

/* Method to create and return the animation for the argument layer. 
   Caller will set delegate, name, duration & add animation to layer */
- (CAAnimation *)animationForLayer:(CALayer *)layer ofSize:(CGSize)size;

/* Reset Config settings */
- (void)reset;

@end



/* View to display prime numbers */
@interface AnimationView : UIView

/* Animation configuration */
@property (nonatomic, retain) id<Config> config;

/* Animation speed. This is a factor */
@property (nonatomic, assign) NSUInteger speed;

/* Animation state */
@property (nonatomic, readonly, assign) BOOL animating;
@property (nonatomic, readonly, assign) BOOL paused;

/* Start animation */
- (void)start;

/* Stop animation */
- (void)stop;

/* Pause animation */
- (void)pause;

/* Resume animation */
- (void)resume;

/* Calling reset will implicitly call stop */
- (void)reset;

@end
