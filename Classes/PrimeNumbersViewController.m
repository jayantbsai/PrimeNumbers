//
//  PrimeNumbersViewController.m
//  PrimeNumbers
//
//  Created by Jayant Sai on 10/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PrimeNumbersViewController.h"

#import "AnimationView.h"

#import "StarFieldConfig.h"
#import "RainConfig.h"
#import "PrintConfig.h"


#pragma mark Class extension

@interface PrimeNumbersViewController ()

#pragma mark animation
@property (nonatomic, assign) CGFloat animationSpeed;
@property (nonatomic, assign) BOOL configReset;

@end



#pragma mark -

@implementation PrimeNumbersViewController

@synthesize animationView;
@synthesize startBut, stopBut, resetBut;
@synthesize configView = _configView, configReset;

@synthesize animationSpeed;


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    id config = [[StarFieldConfig alloc] initWithView:self.animationView];
    self.animationView.config = config;
    [config release];
    
    self.animationView.speed = kConfigViewInitialAnimationSpeed;
    
    [self start];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
	[_configView release];
    _configView = nil;
}


- (void)dealloc {
    self.animationView = nil;
    
    if (_configView) {
        [_configView release];
        _configView = nil;
    }
    
    [super dealloc];
}


#pragma mark lazy loading


- (ConfigViewController *)configView {
    if (!_configView) {
        ConfigViewController *vc = [[ConfigViewController alloc] initWithNibName:@"ConfigView" bundle:nil];
        vc.modalTransitionStyle = UIModalTransitionStylePartialCurl;
        vc.delegate = self;
        _configView = [vc retain];
        [vc release];
    }
    
    return _configView;
}


#pragma mark methods


- (IBAction)start {
    [self.animationView start];
    
    self.startBut.enabled = NO;
    self.stopBut.enabled = YES;
    self.resetBut.enabled = NO;
}


- (IBAction)stop {
    [self.animationView stop];
    
    self.startBut.enabled = YES;
    self.stopBut.enabled = NO;
    self.resetBut.enabled = YES;
}


- (IBAction)reset {
    [self.animationView reset];
    
    self.startBut.enabled = YES;
    self.stopBut.enabled = NO;
    self.resetBut.enabled = NO;
}


- (IBAction)showConfig {
    [self.animationView pause];
    [self presentModalViewController:self.configView animated:YES];
}


#pragma mark ConfigViewControllerDelegate


- (void)configViewController:(ConfigViewController *)controller didChangeConfig:(ConfigType)configType {
    //create new view to replace old animation view
    AnimationView *animView = [[AnimationView alloc] initWithFrame:self.animationView.frame];
    [self.animationView.superview addSubview:animView];
    [self.animationView removeFromSuperview];
    
    NSUInteger speed = self.animationView.speed;
    
    [self.animationView stop];
    self.animationView = nil;

    self.animationView = animView;
    
    //new config
    id config = nil;
    if (configType == kConfigTypeStarField) {
        config = [[StarFieldConfig alloc] initWithView:self.animationView];
    }
    else if (configType == kConfigTypeRain) {
        config = [[RainConfig alloc] initWithView:self.animationView];
    }
    else if (configType == kConfigTypePrint) {
        config = [[PrintConfig alloc] initWithView:self.animationView];
    }
    
    self.animationView.config = config;
    self.animationView.speed = speed;
    
    self.configReset = YES;
    
    [config release];
    [animView release];
}


- (void)configViewController:(ConfigViewController *)controller didChangeAnimationSpeed:(NSUInteger)speed {
    self.animationView.speed = speed;
}


- (void)configViewControllerDidDismiss:(ConfigViewController *)controller {
    if (self.configReset) {
        [self start];
    }
    else {
        [self.animationView resume];
    }
    
    self.configReset = NO;
}


@end
