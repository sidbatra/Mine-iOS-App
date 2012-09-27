//
//  DWLoginViewController.m
//  Mine
//
//  Created by Siddharth Batra on 7/25/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWLoginViewController.h"

#import <MediaPlayer/MediaPlayer.h>

#import "DWAnalyticsManager.h"
#import "DWConstants.h"


static NSString* const kVideoIntro = @"mine_intro_640x280.mp4";





@interface DWMoviePlayerController : MPMoviePlayerViewController
@end

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWMoviePlayerController

/**
 * Subcasses to Force MPMoviePlayerViewController to only play in landscape.
 */


/**
 * iOS 5 Only
 */
//----------------------------------------------------------------------------------------------------
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

/**
 * iOS 6 Only
 */
//----------------------------------------------------------------------------------------------------
-(BOOL)shouldAutorotate {
    return NO;
}

//----------------------------------------------------------------------------------------------------
-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

//----------------------------------------------------------------------------------------------------
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeLeft;
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
@synthesize loadingFBImageView              = _loadingFBImageView;
@synthesize loadingTWImageView              = _loadingTWImageView;
@synthesize loadingFBSpinner                = _loadingFBSpinner;
@synthesize loadingTWSpinner                = _loadingTWSpinner;
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
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(playbackDidFinish:)
													 name:MPMoviePlayerPlaybackDidFinishNotification
												   object:nil];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Home View"];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
}

//----------------------------------------------------------------------------------------------------
- (void)startLoadingFB {
    self.view.userInteractionEnabled = NO;
    
    self.loadingFBImageView.hidden = NO;
    self.loadingFBSpinner.hidden = NO;
    [self.loadingFBSpinner startAnimating];
}

//----------------------------------------------------------------------------------------------------
- (void)stopLoadingFB {
    self.view.userInteractionEnabled = YES;
    
    self.loadingFBImageView.hidden = YES;
    self.loadingFBSpinner.hidden = YES;
    [self.loadingFBSpinner stopAnimating];    
}

//----------------------------------------------------------------------------------------------------
- (void)startLoadingTW {
    self.view.userInteractionEnabled = NO;
    
    self.loadingTWImageView.hidden = NO;
    self.loadingTWSpinner.hidden = NO;
    [self.loadingTWSpinner startAnimating];
}

//----------------------------------------------------------------------------------------------------
- (void)stopLoadingTW {
    self.view.userInteractionEnabled = YES;
    
    self.loadingTWImageView.hidden = YES;
    self.loadingTWSpinner.hidden = YES;
    [self.loadingTWSpinner stopAnimating];    
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
    
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft
                                                          animated:NO];
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Intro Video Played"];
}

//----------------------------------------------------------------------------------------------------
- (IBAction)loginWithFBButtonClicked:(id)sender {
    [self.facebookConnect authorize];
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Facebook Signup Button Clicked"];
}

//----------------------------------------------------------------------------------------------------
- (IBAction)loginWithTWButtonClicked:(id)sender {
    [[self.delegate loginViewNavigationController] pushViewController:self.twitterConnectViewController
                                                             animated:YES];
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Twitter Signup Button Clicked"];
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
    [self stopLoadingFB];
    [self stopLoadingTW];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWFacebookConnectDelegate

//----------------------------------------------------------------------------------------------------
- (void)fbAuthenticatedWithToken:(NSString *)accessToken {
    [self startLoadingFB];
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
    
    [self startLoadingTW];
    
    [[self.delegate loginViewNavigationController] popViewControllerAnimated:YES];
    
    [self.usersController createUserFromTwitterWithAccessToken:@"229722601-JXIcNu2bfdFjRye6fYPxLi3Tcm2G5VPa7lqbKM9O"
                                          andAccessTokenSecret:@"xzMyCZkWhnKM5T7qa3B7YgwNzkMAEGDGQb8QtXIVIo"];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)playbackDidFinish:(NSNotification*)notification {
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait
                                                          animated:NO];
    }
}

@end
