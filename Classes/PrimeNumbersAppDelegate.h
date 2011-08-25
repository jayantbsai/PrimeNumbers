//
//  PrimeNumbersAppDelegate.h
//  PrimeNumbers
//
//  Created by Jayant Sai on 10/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PrimeNumbersViewController;

@interface PrimeNumbersAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    PrimeNumbersViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet PrimeNumbersViewController *viewController;

@end

