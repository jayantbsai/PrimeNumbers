//
//  ConfigViewController.h
//  PrimeNumbers
//
//  Created by Jayant Sai on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kConfigViewInitialAnimationSpeed 5


@protocol ConfigViewControllerDelegate;
@protocol Config;


/* Configuration view */
@interface ConfigViewController : UIViewController {

}

@property (nonatomic, retain) IBOutlet UISegmentedControl *animationTypes;
@property (nonatomic, retain) IBOutlet UIView *topMarginView;
@property (nonatomic, retain) IBOutlet UITextView *instructionsTextView;

@property (nonatomic, retain) IBOutlet UILabel *speedLabel;
@property (nonatomic, retain) IBOutlet UISlider *speedSlider;

@property (nonatomic, assign) id<ConfigViewControllerDelegate> delegate;

- (IBAction)dismiss;
- (IBAction)animationTypeChanged:(id)sender;
- (IBAction)sliderValueChanged:(id)sender;

@end



/* configuration types */
typedef enum {
    kConfigTypeStarField = 0,
    kConfigTypeRain,
    kConfigTypePrint
} ConfigType;



/* Delegate to notify of config changes */
@protocol ConfigViewControllerDelegate

- (void)configViewController:(ConfigViewController *)controller didChangeConfig:(ConfigType)config;
- (void)configViewController:(ConfigViewController *)controller didChangeAnimationSpeed:(NSUInteger)speed;
- (void)configViewControllerDidDismiss:(ConfigViewController *)controller;

@end
