//
//  ViewController.h
//  Active Player
//
//  Created by Alex King on 10/7/14.
//  Copyright (c) 2014 Alex King. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CoreMotion/CoreMotion.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UISlider *activeVolumeSlider;
@property (strong, nonatomic) IBOutlet UISlider *restVolumeSlider;
@property (strong, nonatomic) IBOutlet UISlider *sensitivitySlider;
@property (strong, nonatomic) IBOutlet UISlider *responsivenessSlider;
@property (strong, nonatomic) IBOutlet UISwitch *controlSwitch;

@end

