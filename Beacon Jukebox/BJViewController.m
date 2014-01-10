//
//  BJViewController.m
//  Beacon Jukebox
//
//  Created by Wojciech Czekalski on 10.01.2014.
//  Copyright (c) 2014 Wojciech Czekalski. All rights reserved.
//

#import "BJViewController.h"
#import "ESTBeaconManager.h"
#import "CocoaLibSpotify.h"

@interface BJViewController () <ESTBeaconManagerDelegate>

@property (nonatomic, strong) ESTBeaconManager *manager;
@property (nonatomic, assign) BOOL isLoggedIn;
@property (nonatomic, assign) BOOL allowsBecomingClient;

@end

#define REGION_MAJOR 452

@implementation BJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typicall from a nib.
    
    self.manager = [[ESTBeaconManager alloc] init];
    self.manager.delegate = self;
    self.manager.avoidUnknownStateBeacons = YES;
    
    ESTBeaconRegion *region = [[ESTBeaconRegion alloc] initRegionWithMajor:REGION_MAJOR identifier:@"Jukebox Zone"];
    
    [self.manager startMonitoringForRegion:region];
    [self.manager requestStateForRegion:region];
    
    // Show info
    
    if (!self.isLoggedIn) {
        ;
    } else {
        
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


#pragma mark - player mode

#pragma mark - Manager delegate

-(void) beaconManager:(ESTBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(ESTBeaconRegion *)region {
    ESTBeacon *beacon = beacons[0];
    
    if (beacon.minor == [NSNumber numberWithInteger:BJZoneStateActive]) {
        
    } else if (beacon.minor == [NSNumber numberWithInteger:BJZoneStateInactive]) {
        
    }
}

@end
