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
}

/**
 * Users data controller for logging in the user.
 */
@property (nonatomic,strong) DWUsersController *usersController;

/**
 * Interface for implementing an FB connect.
 */
@property (nonatomic,strong) DWFacebookConnect *facebookConnect;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWLoginViewController

@synthesize loginWithFBButton   = _loginWithFBButton;
@synthesize delegate            = _delegate;
@synthesize usersController     = _usersController;
@synthesize facebookConnect     = _facebookConnect;

//----------------------------------------------------------------------------------------------------
- (id)init
{
    self = [super init];
    
    if (self) {
        
        self.usersController = [[DWUsersController alloc] init];
        self.usersController.delegate = self;
        
        self.facebookConnect = [[DWFacebookConnect alloc] init];
        self.facebookConnect.delegate = self;
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


@end
