//
//  PrimeNumbersViewController.h
//  PrimeNumbers
//
//  Created by Jayant Sai on 10/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ConfigViewController.h"


@class AnimationView;


/* Main view controller */
@interface PrimeNumbersViewController : UIViewController <ConfigViewControllerDelegate> {
    ConfigViewController *_configView;
}

@property (nonatomic, retain) IBOutlet AnimationView *animationView;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *startBut;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *stopBut;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *resetBut;

@property (nonatomic, retain) IBOutlet ConfigViewController *configView;

/* Manage animation state */
- (IBAction)start;
- (IBAction)stop;
- (IBAction)reset;

/* Show animation configuration */
- (IBAction)showConfig;

@end
