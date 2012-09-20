//
//  DWLoginViewController.m
//  Mine
//
//  Created by Siddharth Batra on 7/25/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWLoginViewController.h"

#import <MediaPlayer/MediaPlayer.h>


static NSString* const kVideoIntro = @"mine_intro_640x280.mp4";





@interface DWMoviePlayerController : MPMoviePlayerViewController
@end

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWMoviePlayerController

/**
 * Force MPMoviePlayerViewController to only play in landscape.
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}
@end




/**
 * Private declarations
 */
@interface DWLoginViewController () {
    DWUsersController *_usersController;
    
    DWFacebookConnect *_facebookConnect;
    DWTwitterConnectViewController  *_twitterConnectViewController;
    
    DWMoviePlayerController *_moviePlayerController;
}

/**
 * Users data controller for logging in the user.
 */
@property (nonatomic,strong) DWUsersController *usersController;

/**
 * Interface for implementing a FB connect.
 */
@property (nonatomic,strong) DWFacebookConnect *facebookConnect;

/**
 * Interface for implementing a TW connect.
 */
@property (nonatomic,strong) DWTwitterConnectViewController *twitterConnectViewController;

/**
 * Video player interface.
 */
@property (nonatomic,strong) DWMoviePlayerController *moviePlayerController;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWLoginViewController

@synthesize playButton                      = _playButton;
@synthesize loginWithFBButton               = _loginWithFBButton;
@synthesize loginWithTWButton               = _loginWithTWButton;
@synthesize delegate                        = _delegate;
@synthesize usersController                 = _usersController;
@synthesize facebookConnect                 = _facebookConnect;
@synthesize twitterConnectViewController    = _twitterConnectViewController;
@synthesize moviePlayerController           = _moviePlayerController;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if (self) {
        self.usersController = [[DWUsersController alloc] init];
        self.usersController.delegate = self;
        
        self.facebookConnect = [[DWFacebookConnect alloc] init];
        self.facebookConnect.delegate = self;
        
        self.twitterConnectViewController = [[DWTwitterConnectViewController alloc] init];
        self.twitterConnectViewController.updateCurrentUser = NO;
        self.twitterConnectViewController.delegate = self;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark IBActions

//----------------------------------------------------------------------------------------------------
- (IBAction)playButtonClicked:(id)sender {
    
    NSString *mediaPath = [[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:kVideoIntro];
    self.moviePlayerController = [[DWMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:mediaPath]];
    self.moviePlayerController.moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
        
    [[self.delegate loginViewNavigationController] presentMoviePlayerViewControllerAnimated:self.moviePlayerController];
    [self.moviePlayerController.moviePlayer play];
}

//----------------------------------------------------------------------------------------------------
- (IBAction)loginWithFBButtonClicked:(id)sender {
    [self.facebookConnect authorize];
}

//----------------------------------------------------------------------------------------------------
- (IBAction)loginWithTWButtonClicked:(id)sender {
    [[self.delegate loginViewNavigationController] pushViewController:self.twitterConnectViewController
                                                             animated:YES];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWUsersControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)userCreated:(DWUser*)user {
    [self.delegate userLoggedIn:user];
}

//----------------------------------------------------------------------------------------------------
- (void)userCreationError:(NSString*)error {
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWFacebookConnectDelegate

//----------------------------------------------------------------------------------------------------
- (void)fbAuthenticatedWithToken:(NSString *)accessToken {
    [self.usersController createUserFromFacebookWithAccessToken:accessToken];
}

//----------------------------------------------------------------------------------------------------
- (void)fbAuthenticationFailed {
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWTwitterConnectViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)twitterAuthorizedWithAccessToken:(NSString *)accessToken 
                    andAccessTokenSecret:(NSString *)accessTokenSecret {
    
    [[self.delegate loginViewNavigationController] popViewControllerAnimated:YES];
    
    [self.usersController createUserFromTwitterWithAccessToken:@"229722601-JXIcNu2bfdFjRye6fYPxLi3Tcm2G5VPa7lqbKM9O"
                                          andAccessTokenSecret:@"xzMyCZkWhnKM5T7qa3B7YgwNzkMAEGDGQb8QtXIVIo"];
}

//----------------------------------------------------------------------------------------------------
- (void)twitterConfigured {
}

@end
