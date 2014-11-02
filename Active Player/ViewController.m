//
//  ViewController.m
//  Active Player
//
//  Created by Alex King on 10/7/14.
//  Copyright (c) 2014 Alex King. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic) float activeVolume;
@property (nonatomic) float restVolume;
@property (nonatomic) float sensitivity;
@property (nonatomic) float responsiveness;

@property (strong, nonatomic) CMMotionManager *motionManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.activeVolumeSlider setValue:0.7];
    [self.restVolumeSlider setValue:0.15];
    [self.sensitivitySlider setValue:0.85];
    [self.responsivenessSlider setValue:0.3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)sliderChangedValue:(UISlider *)sender
{
    if (sender == self.activeVolumeSlider) {
        MPMusicPlayerController *musicPlayer = [MPMusicPlayerController systemMusicPlayer];
        [musicPlayer setVolume:sender.value];
        self.activeVolume = sender.value;
    }
    else if (sender == self.restVolumeSlider)
    {
        self.restVolume = sender.value;
    }
    else if (sender == self.sensitivitySlider)
    {
        self.sensitivity = sender.value;
    }
    else if (sender == self.responsivenessSlider)
    {
        self.responsiveness = sender.value;
    }
}

- (IBAction)toggleButtonPressed:(id)sender
{
    if ([self.controlSwitch isOn])
    {
        [self.motionManager startAccelerometerUpdates];
    }
    else
    {
        [self.motionManager stopAccelerometerUpdates];
    }
}

@end
