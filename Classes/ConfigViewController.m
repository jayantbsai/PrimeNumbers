    //
//  ConfigViewController.m
//  PrimeNumbers
//
//  Created by Jayant Sai on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ConfigViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "StarFieldConfig.h"
#import "RainConfig.h"
#import "PrintConfig.h"



#pragma mark Class extension

@interface ConfigViewController ()

- (void)updateSpeedLabel:(NSUInteger)speed;

@end



#pragma mark -

@implementation ConfigViewController

@synthesize animationTypes, topMarginView, instructionsTextView;
@synthesize speedLabel, speedSlider;
@synthesize delegate;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.animationTypes setTitle:NSLocalizedString(@"configview.type.Star Field", nil)
                forSegmentAtIndex:kConfigTypeStarField];
    
    [self.animationTypes setTitle:NSLocalizedString(@"configview.type.Rain", nil)
                forSegmentAtIndex:kConfigTypeRain];
    
    [self.animationTypes setTitle:NSLocalizedString(@"configview.type.Print", nil)
                forSegmentAtIndex:kConfigTypePrint];
    
    self.topMarginView.layer.cornerRadius = 10.0;
    self.instructionsTextView.layer.cornerRadius = 10.0;
    
    self.animationTypes.selectedSegmentIndex = kConfigTypeStarField;
    self.instructionsTextView.text = NSLocalizedString(@"configview.instructions.Star Field", nil);
    
    self.speedSlider.value = kConfigViewInitialAnimationSpeed;
    [self updateSpeedLabel:kConfigViewInitialAnimationSpeed];
}


- (void)dealloc {
    self.animationTypes = nil;
    self.topMarginView = nil;
    self.instructionsTextView = nil;
    
    self.speedLabel = nil;
    self.speedSlider = nil;
    
    [super dealloc];
}


- (void)viewDidDisappear:(BOOL)animated {
    [self.delegate configViewControllerDidDismiss:self];
}


#pragma mark methods


- (void)updateSpeedLabel:(NSUInteger)speed {
    self.speedLabel.text = [NSString stringWithFormat:@"%@ (%u seconds)", NSLocalizedString(@"configview.Speed", nil), speed];
}


- (IBAction)dismiss {
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)animationTypeChanged:(id)sender {
    switch (self.animationTypes.selectedSegmentIndex) {
        case kConfigTypeStarField:
            self.instructionsTextView.text = NSLocalizedString(@"configview.instructions.Star Field", nil);
            break;
        case kConfigTypeRain:
            self.instructionsTextView.text = NSLocalizedString(@"configview.instructions.Rain", nil);
            break;
        case kConfigTypePrint:
            self.instructionsTextView.text = NSLocalizedString(@"configview.instructions.Print", nil);
            break;
    }
    
    [self.delegate configViewController:self didChangeConfig:self.animationTypes.selectedSegmentIndex];
    
}


- (IBAction)sliderValueChanged:(id)sender {
    NSUInteger speed = roundf(((UISlider *) sender).value);
    [self updateSpeedLabel:speed];
    
    [self.delegate configViewController:self didChangeAnimationSpeed:speed];
}


@end
