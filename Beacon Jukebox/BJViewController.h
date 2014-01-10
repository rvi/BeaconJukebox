//
//  BJViewController.h
//  Beacon Jukebox
//
//  Created by Wojciech Czekalski on 10.01.2014.
//  Copyright (c) 2014 Wojciech Czekalski. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BJPlayerMode) {
    BJPlayerModeClient,
    BJPlayerModeServer
};

typedef NS_ENUM(NSInteger, BJZoneState) {
    BJZoneStateActive,
    BJZoneStateInactive
};

@interface BJViewController : UIViewController

@property (nonatomic, assign) BJPlayerMode playerMode;

@end
