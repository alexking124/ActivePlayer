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

@property (strong, nonatomic) NSNumber *magnitude;
@property (nonatomic) float newMagnitude;
@property (nonatomic) float lastMagnitude;

@property (strong, nonatomic) NSMutableArray *accelerationData;
@property (strong, nonatomic) NSDate *lastUpdateTime;

@property (strong, nonatomic) CMMotionManager *motionManager;
@property (strong, nonatomic) UISlider *volumeViewSlider;

@property (strong, nonatomic) NSOperationQueue *backgroundQueue;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.activeVolumeSlider setValue:0.7];
    [self.restVolumeSlider setValue:0.15];
    [self.sensitivitySlider setValue:0.85];
    [self.responsivenessSlider setMinimumValue:1.0];
    [self.responsivenessSlider setMaximumValue:10.0];
    [self.responsivenessSlider setValue:3.0];
    [self.controlSwitch setOn:NO];
    
    self.activeVolume = self.activeVolumeSlider.value;
    self.restVolume = self.restVolumeSlider.value;
    self.sensitivity = self.sensitivitySlider.value;
    self.responsiveness = self.responsivenessSlider.value;
    
    self.motionManager = [[CMMotionManager alloc] init];
    [self.motionManager setDeviceMotionUpdateInterval:1.0/60.0];
    
    self.accelerationData = [[NSMutableArray alloc] init];
    
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            self.volumeViewSlider = (UISlider*)view;
            break;
        }
    }
    
    self.magnitude = [[NSNumber alloc] init];
    self.newMagnitude = 0.0;
    self.lastMagnitude = 0.0;
    
    self.lastUpdateTime = [NSDate date];
    
    self.backgroundQueue = [[NSOperationQueue alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)sliderChangedValue:(UISlider *)sender
{
    if (sender == self.activeVolumeSlider)
    {
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
        self.responsiveness = round(sender.value);
    }
}

- (IBAction)toggleButtonPressed:(id)sender
{
    if ([self.controlSwitch isOn])
    {
        [self.motionManager startDeviceMotionUpdatesToQueue:self.backgroundQueue withHandler:^ (CMDeviceMotion *motionData, NSError *error) {
            [self receivedNewMotionUpdate:motionData];
        }];
    }
    else
    {
        [self.motionManager stopDeviceMotionUpdates];
    }
}

- (void)receivedNewMotionUpdate:(CMDeviceMotion*)motionData
{
    CMAcceleration newAcceleration = [motionData userAcceleration];
    float x = newAcceleration.x;
    float y = newAcceleration.y;
    float z = newAcceleration.z;
    //NSLog(@"Got acceleration with x: %f, y: %f, z: %f", x, y, z);
    
    self.lastMagnitude = self.newMagnitude;
    self.newMagnitude = sqrt(x * x + y * y + z * z);
    float delta = self.newMagnitude - self.lastMagnitude;
    self.magnitude = [NSNumber numberWithDouble:fabsf(self.magnitude.floatValue * 0.9 + delta)]; //perform low-cut filter
    [self.accelerationData addObject:self.magnitude];
    
    //NSLog(@"Magnitude of acceleration: %f", self.newMagnitude);
    
    if (-[self.lastUpdateTime timeIntervalSinceNow] >= 2 / self.responsiveness)
    {
        if ([self average:self.accelerationData] > (0.11 * self.sensitivity))
        {
            [self.volumeViewSlider setValue:self.activeVolume animated:NO];
            [self.volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            [self.volumeViewSlider setValue:self.restVolume animated:NO];
            [self.volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
        self.lastUpdateTime = [NSDate date];
        [self.accelerationData removeAllObjects];
    }
    
}

- (float)average:(NSMutableArray*)array
{
    float average = [self sum:array] / array.count;
    return average;
}

- (float)sum:(NSMutableArray*)array
{
    float total = 0.0;
    NSNumber *number;
    for (number in array)
    {
        total = total + number.floatValue;
    }
    return total;
}

@end
