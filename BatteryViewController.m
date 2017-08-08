//
//  BatteryViewController.m
//
//
//  Created by Rajeev on 12/06/17.
//

#import "BatteryViewController.h"
#import <sys/utsname.h>


@interface BatteryViewController () {
    
    double batLeft;
    CGFloat brightness;
    int batteryState;
}

@property (weak, nonatomic) IBOutlet MBCircularProgressBarView *progressBar;
@property (weak, nonatomic) IBOutlet UILabel *lblBatteryTimeRem;

@end

@implementation BatteryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(batteryCharged)
     name:UIDeviceBatteryLevelDidChangeNotification
     object:nil
     ];
    
    [self getBrightnessOfiPhone];
    [self battery];
    [self getStateOfiPhone];
}

- (void)batteryCharged
{
    float currBatteryLev = [UIDevice currentDevice].batteryLevel;
    // get how much the battery needs to be charged yet
    float remBatteryLev = 1.0 - currBatteryLev;
    remBatteryLev = remBatteryLev*100;
    NSLog(@"Total time %d", remBatteryLev);
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
}

#pragma mark - NSNotfication callback Methods
#pragma mark ===================================================

-(void)iPhoneStateChanged:(NSNotification *)notice {
    
    batteryState = (int)[notice.object batteryState];
    NSLog(@"battery status: %d",batteryState); // 0 unknown, 1 unplegged, 2 charging, 3 full
}

-(void) batteryChanged:(NSNotification*)notification
{
    [super batteryChanged:notification];
    batLeft = (float)[notification.object batteryLevel] * 100;
    NSLog(@"battery left: %f", batLeft);
}

-(void) brightnessChanged:(NSNotification*)notification
{
    [super brightnessChanged:notification];
    brightness = (float)[notification.object brightness] * 100;
    NSLog(@"brightness is %0.2f", brightness);
}

#pragma mark - Device, Brightness, Internet and Battery Fetch Methods
#pragma mark ==========================================================

-(void) battery {
    
    UIDevice *myDevice = [UIDevice currentDevice];
    [myDevice setBatteryMonitoringEnabled:YES];
    batLeft = (float)[myDevice batteryLevel] * 100;
}

-(void)getStateOfiPhone {
    
    batteryState = [[UIDevice currentDevice] batteryState];
    NSLog(@"battery status: %d",batteryState); // 0 unknown, 1 unplegged, 2 charging, 3 full
}

-(void)getBrightnessOfiPhone {

    brightness = [UIScreen mainScreen].brightness * 100;
    NSLog(@"brightness is %f", brightness);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
