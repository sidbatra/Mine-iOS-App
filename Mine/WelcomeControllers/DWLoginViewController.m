//
//  DWLoginViewController.m
//  Mine
//
//  Created by Siddharth Batra on 7/25/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWLoginViewController.h"

/**
 * Private declarations
 */
@interface DWLoginViewController () {
    DWUsersController *_usersController;
    
    DWFacebookConnect *_facebookConnect;
    DWTwitterConnectViewController  *_twitterConnectViewController;
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

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWLoginViewController

@synthesize loginWithFBButton               = _loginWithFBButton;
@synthesize loginWithTWButton               = _loginWithTWButton;
@synthesize delegate                        = _delegate;
@synthesize usersController                 = _usersController;
@synthesize facebookConnect                 = _facebookConnect;
@synthesize twitterConnectViewController    = _twitterConnectViewController;

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
    
    [self.usersController createUserFromTwitterWithAccessToken:@"45032868-u6AmUUC3Lwb64TVQifzkEgey9r6zayISQXy0aJ2SF"
                                          andAccessTokenSecret:@"4TJIHLVPDrA29dohWvdn6lxcferKWPFCEelZpHIVo"];
}

//----------------------------------------------------------------------------------------------------
- (void)twitterConfigured {
}

@end
