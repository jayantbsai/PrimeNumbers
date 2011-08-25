//
//  PrintConfig.m
//  PrimeNumbers
//
//  Created by Jayant Sai on 10/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PrintConfig.h"
#import <QuartzCore/QuartzCore.h>


@interface PrintConfig ()

@property (nonatomic, assign) UIView *view;
@property (nonatomic, assign) CGSize boundsSize;
@property (nonatomic, assign) CGFloat offsetX;
@property (nonatomic, assign) CGFloat offsetY;

@end



@implementation PrintConfig

@synthesize view, boundsSize, offsetX, offsetY;


- (id)initWithView:(UIView *)v {
    if (self = [super init]) {
        self.view = v;
        self.boundsSize = v.frame.size;
        [self reset];
    }
    
    return self;
}


- (void)reset {
    self.offsetX = 0.0;
    self.offsetY = 0.0;
    
    self.view.bounds = CGRectZero;
}


- (CAAnimation *)animationForLayer:(CALayer *)layer ofSize:(CGSize)size {
    if ((self.offsetX + size.width) >= self.boundsSize.width) {
        self.offsetX = 0;
        self.offsetY += size.height;

        if (self.offsetY + size.height >= self.boundsSize.height) {
            self.view.bounds = CGRectMake(0.0, self.view.bounds.origin.y + size.height, self.boundsSize.width, self.boundsSize.height);
        }
    }
    
    layer.frame = CGRectMake(self.offsetX, self.offsetY, size.width, size.height);
    
    self.offsetX += size.width;
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anim.autoreverses = NO;
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;

    anim.fromValue = [NSNumber numberWithFloat:1.0];
    anim.toValue = [NSNumber numberWithFloat:0.0];
    
    return anim;
}


@end
