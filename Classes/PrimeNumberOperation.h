//
//  PrimeNumberOperation.h
//  PrimeNumbers
//
//  Created by Jayant Sai on 10/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


/* Operation to generate prime numbers */
@interface PrimeNumberOperation : NSOperation {

}

/* Target/action called on main thread. The action will be called
   and passed a NSNumber argument, which is the prime number */
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;

/* Starting number. Default is 2 */
@property (nonatomic, assign) NSUInteger startNum;

/* Initialize operation. The action is called on the target on the
   main thread. The action is passed the prime number NSNumber */
- (id)initWithTarget:(id)target action:(SEL)action;

@end
