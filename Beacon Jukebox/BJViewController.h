//
//  BJViewController.h
//  Beacon Jukebox
//
//  Created by Wojciech Czekalski on 10.01.2014.
//  Copyright (c) 2014 Wojciech Czekalski. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BJPlayerMode) {
    BJPlayerModeNone,
    BJPlayerModeClient,
    BJPlayerModeServer
};

typedef NS_ENUM(NSInteger, BJZoneState) {
    BJZoneStateActive,
    BJZoneStateInactive
};

@interface BJViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (nonatomic, assign) BJPlayerMode playerMode;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (weak, nonatomic) IBOutlet UIButton *stopPlayingButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

- (IBAction)startLogin:(UIButton *)sender;
- (IBAction)joinParty:(UIButton *)sender;
- (IBAction)stopServerSession:(UIButton *)sender;
- (IBAction)startServerSession:(UIButton *)sender;



@end
