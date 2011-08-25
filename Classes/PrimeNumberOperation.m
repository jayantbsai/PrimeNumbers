//
//  PrimeNumberOperation.m
//  PrimeNumbers
//
//  Created by Jayant Sai on 10/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PrimeNumberOperation.h"



#pragma mark Class extension

@interface PrimeNumberOperation ()

/* TODO: Should this be non-atomic? */
@property (nonatomic) BOOL executing;

@end



#pragma mark -


@implementation PrimeNumberOperation

@synthesize target, action;
@synthesize startNum;
@synthesize executing;


- (id)initWithTarget:(id)tgt action:(SEL)act {
    if (self = [super init]) {
        self.target = tgt;
        self.action = act;
        self.startNum = 2;
    }
    
    return self;
}


- (void)start {
    self.executing = YES;
    
    for (NSUInteger n=self.startNum; n<NSUIntegerMax; n++) {
        // if thread has been cancelled, set restart number and finish
        if ([self isCancelled]) {
            break;
        }
        
        // find prime numbers.
        BOOL prime = YES;
        for (NSUInteger d=2, dl=(NSUInteger)ceil(n/2.0); d<dl; d++) {
            if ((n % d) == 0) {
                prime = NO;
                break;
            }
        }
        
        // call action with prime number
        if (prime && ![self isCancelled]) {
            NSNumber *num = [[NSNumber alloc] initWithUnsignedInteger:n];
            [self.target performSelectorOnMainThread:self.action
                                          withObject:num
                                       waitUntilDone:YES];
            [num release];
        }
    }
    
    self.executing = NO;
}


- (BOOL)isConcurrent {
    return YES;
}


- (BOOL)isFinished {
    return !self.executing;
}


@end
