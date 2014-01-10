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
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface BJViewController () <ESTBeaconManagerDelegate, SPLoginViewControllerDelegate, MCSessionDelegate,MCBrowserViewControllerDelegate>

@property (nonatomic, strong) ESTBeaconManager *manager;
@property (nonatomic, assign) BOOL isLoggedIn;
@property (nonatomic, assign) BOOL allowsBecomingClient;
@property (nonatomic, strong) NSMutableArray *queue;
@property (nonatomic, strong) SPPlaybackManager *playbackManager;


@property (nonatomic, strong) NSMutableArray *peers;

@property (nonatomic, strong) MCSession *session;

@property (nonatomic, strong) MCNearbyServiceAdvertiser *advertiser;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiserAssistant;

@property (nonatomic, strong) MCNearbyServiceBrowser *browser;


-(void) playNextSong;

@end

#include <stdint.h>
#include <stdlib.h>
const uint8_t g_appkey[] = {
	0x01, 0x15, 0xEF, 0x08, 0xA5, 0xCF, 0x1C, 0x87, 0xE3, 0xF3, 0x5D, 0x07, 0xEB, 0x77, 0x53, 0x6C,
	0x3C, 0x67, 0x47, 0x90, 0x37, 0x89, 0x1D, 0xC8, 0x19, 0x0E, 0xBB, 0x42, 0x30, 0x65, 0x2E, 0xCB,
	0xF7, 0x95, 0x4D, 0x8B, 0x2D, 0x7A, 0xDD, 0x7A, 0x53, 0x17, 0x01, 0x86, 0x1A, 0xA6, 0x58, 0xA7,
	0x56, 0x5A, 0xCD, 0x31, 0xFF, 0xE6, 0x9E, 0xC4, 0x89, 0x75, 0x25, 0x40, 0x01, 0x5E, 0xDC, 0xDE,
	0xCF, 0x3A, 0xE2, 0xA5, 0x84, 0x08, 0x4A, 0x22, 0xBF, 0xD0, 0x6C, 0xEC, 0xCB, 0x8D, 0x27, 0xA3,
	0xE0, 0x9A, 0x4D, 0x84, 0x48, 0xB6, 0x13, 0x1E, 0xC5, 0xD4, 0xDE, 0xFD, 0x13, 0xCE, 0x2C, 0xC5,
	0x9E, 0x72, 0x24, 0x4A, 0xE6, 0x81, 0x6A, 0x73, 0x6F, 0xDF, 0x1A, 0x20, 0x49, 0x1F, 0x40, 0x0C,
	0x5C, 0x1B, 0x9B, 0xF3, 0xB5, 0x33, 0x74, 0x70, 0xB6, 0x3E, 0xC5, 0xDD, 0x66, 0x8D, 0xAE, 0x3E,
	0xCE, 0x03, 0xC4, 0xE5, 0xDD, 0x4D, 0x0D, 0x8C, 0x04, 0x5C, 0xFD, 0x3E, 0x10, 0x8F, 0xA6, 0x14,
	0xA4, 0xC3, 0xB8, 0xF7, 0x27, 0x75, 0xD5, 0xE0, 0xDE, 0xFD, 0x24, 0x7C, 0x51, 0xBC, 0x72, 0xED,
	0x7F, 0x9E, 0xE0, 0x6A, 0x28, 0x96, 0x19, 0xAC, 0x1A, 0x47, 0x06, 0x5B, 0x7E, 0x07, 0xCF, 0x6D,
	0x9A, 0x4D, 0xB1, 0xFA, 0xBE, 0x8E, 0x9A, 0x16, 0x2D, 0xA4, 0x2C, 0xD0, 0x46, 0x18, 0x0D, 0x27,
	0x5C, 0x32, 0x13, 0x19, 0x60, 0x57, 0xBC, 0x0F, 0xF3, 0x97, 0xE2, 0x3A, 0x9E, 0xF9, 0xDD, 0x5D,
	0xEB, 0xEC, 0xB8, 0x9A, 0x31, 0xCA, 0x0D, 0x06, 0xDF, 0x5D, 0x13, 0xE3, 0x58, 0x0E, 0x42, 0x9F,
	0xBC, 0xC9, 0xC0, 0x94, 0x06, 0xBF, 0x24, 0x67, 0x7A, 0x0D, 0x57, 0x34, 0x5B, 0xAA, 0x40, 0x4D,
	0xC4, 0x12, 0x2C, 0xBA, 0x59, 0xC0, 0x87, 0x63, 0x04, 0x72, 0x64, 0xF4, 0x9F, 0x13, 0x95, 0x5B,
	0x77, 0xF2, 0x5E, 0xE6, 0xE1, 0x53, 0x82, 0x8E, 0x96, 0xFA, 0x6D, 0x8D, 0xD5, 0x4F, 0x5C, 0x0E,
	0xB6, 0xBF, 0xFA, 0x6E, 0x33, 0x7D, 0xB7, 0x91, 0x2C, 0x73, 0xC8, 0xAB, 0x2D, 0x30, 0x11, 0x33,
	0x10, 0xE9, 0xBF, 0xA6, 0x42, 0x67, 0x1A, 0x83, 0xCB, 0x79, 0x71, 0xD0, 0x72, 0xBD, 0xA9, 0xF2,
	0x30, 0xEA, 0x87, 0x66, 0xF3, 0x5E, 0x68, 0x2B, 0xF3, 0xCF, 0x4A, 0x7F, 0x4B, 0xF1, 0x57, 0xCA,
	0xE9,
};
const size_t g_appkey_size = sizeof(g_appkey);

#define REGION_MAJOR 452

@implementation BJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typicall from a nib.
    
    self.peers = [NSMutableArray array];
    
    MCPeerID *localPeerID = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
    
    self.session = [[MCSession alloc] initWithPeer:localPeerID
                                  securityIdentity:nil
                              encryptionPreference:MCEncryptionNone];
    self.session.delegate = self;
    
    
    self.advertiserAssistant = [[MCAdvertiserAssistant alloc] initWithServiceType:@"Jukebox" discoveryInfo:nil session:self.session];
    [self.advertiserAssistant start];

    
    self.manager = [[ESTBeaconManager alloc] init];
    self.manager.delegate = self;
    self.manager.avoidUnknownStateBeacons = YES;
    
    ESTBeaconRegion *region = [[ESTBeaconRegion alloc] initRegionWithMajor:REGION_MAJOR identifier:@"Jukebox Zone"];
    
    [self.manager startMonitoringForRegion:region];
    [self.manager requestStateForRegion:region];
    self.playerMode = BJPlayerModeNone;
    
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
    
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
    
    if (beacon.minor == [NSNumber numberWithInteger:BJZoneStateActive]) {
        if (!self.playButton.hidden) {
            [UIView animateWithDuration:0.5f animations:^{
                self.playButton.alpha = 0.f;
            } completion:^(BOOL finished) {
                self.playButton.hidden = NO;
                self.playButton.alpha = 0.f;
            }];

        }
        self.joinButton.hidden = NO;
        self.joinButton.alpha = 0.f;
        [UIView animateWithDuration:0.5f animations:^{
            self.joinButton.alpha = 1.f;
        }];
    } else if (beacon.minor == [NSNumber numberWithInteger:BJZoneStateInactive]) {
        if (!self.joinButton.hidden) {
            [UIView animateWithDuration:0.5f animations:^{
                self.joinButton.alpha = 0.f;
            } completion:^(BOOL finished) {
                self.joinButton.hidden = NO;
                self.joinButton.alpha = 0.f;
            }];
        }
        self.playButton.hidden = NO;
        self.playButton.alpha = 0.f;
        [UIView animateWithDuration:0.5f animations:^{
            self.playButton.alpha = 1.f;
        }];
    }
}


- (IBAction)startLogin:(UIButton *)sender {
    NSError *error = nil;
    if ([SPSession initializeSharedSessionWithApplicationKey:[NSData dataWithBytes:g_appkey length:g_appkey_size] userAgent:@"com.wczekalski.BeaconJukebox" loadingPolicy:SPAsyncLoadingImmediate error:&error]) {
        SPLoginViewController *loginViewController = [SPLoginViewController loginControllerForSession:[SPSession sharedSession]];
        [self presentViewController:loginViewController animated:YES completion:^{
            ;
        }];
        loginViewController.loginDelegate = self;
    }
    NSLog(@"%@", error);
}

- (IBAction)joinParty:(UIButton *)sender {
    
    MCBrowserViewController *browserViewController =
    [[MCBrowserViewController alloc] initWithServiceType:@"Jukebox" session:self.session];
    browserViewController.delegate = self;
    [self presentViewController:browserViewController
                       animated:YES
                     completion:
     ^{
     }];
}

- (IBAction)stopServerSession:(UIButton *)sender {
}

- (IBAction)startServerSession:(UIButton *)sender {
    
}

-(void) loginViewController:(SPLoginViewController *)controller didCompleteSuccessfully:(BOOL)didLogin {
    
    [UIView animateWithDuration:0.5f animations:^{
        self.loginButton.alpha = 0;
    } completion:^(BOOL finished) {
        self.loginButton.hidden = YES;
        self.loginButton.alpha = 1.f;
    }];
    
    self.playbackManager = [[SPPlaybackManager alloc] initWithPlaybackSession:[SPSession sharedSession]];
    [self startServerSession:nil];
}


-(void) playNextSong {
    if ([self.playbackManager isPlaying]) {
        self.playbackManager.isPlaying = NO;
        [self.playbackManager playTrack:self.queue[1] callback:^(NSError *error) {
            if (!error) {
                [self.queue removeObjectAtIndex:0];
            }
        }];
    }
}


/**************************************************************************************************/
#pragma mark - MCSessionDelegate

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    [self.peers addObject:peerID];
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    NSURL *trackURL = [NSURL URLWithString:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
    
    [SPTrack trackForTrackURL:trackURL inSession:[SPSession sharedSession] callback:^(SPTrack *track) {
        [self.queue addObject:track];
        if (![self.playbackManager isPlaying]) {
            [self playNextSong];
        }
    }];

}
// Received a byte stream from remote peer
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    
    
}

// Start receiving a resource from remote peer
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
    
}

// Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error

{
    
}

- (void)session:(MCSession *)session didReceiveCertificate:(NSArray *)certificate fromPeer:(MCPeerID *)peerID certificateHandler:(void (^)(BOOL accept))certificateHandler
{
    
    certificateHandler(YES);
}

/**************************************************************************************************/
#pragma mark - MCBrowserViewControllerDelegate

- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    [browserViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    [browserViewController dismissViewControllerAnimated:YES completion:NULL];
}

@end
