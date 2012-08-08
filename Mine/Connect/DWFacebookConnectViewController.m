//
//  DWFacebookConnectViewController.m
//  Mine
//
//  Created by Deepak Rao on 8/7/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWFacebookConnectViewController.h"
#import "DWSession.h"

/**
 * Private declarations
 */
@interface DWFacebookConnectViewController () {
    DWFacebookConnect   *_tumblrConnect;
    DWUsersController   *_usersController;
}

/**
 * Wrapper for facebook connect
 */
@property (nonatomic,strong) DWFacebookConnect *facebookConnect;

/**
 * Data controller for the users model.
 */
@property (nonatomic,strong) DWUsersController *usersController;

@end


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWFacebookConnectViewController

@synthesize facebookConnect             = _facebookConnect;
@synthesize usersController             = _usersController;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if (self) {
        self.facebookConnect            = [[DWFacebookConnect alloc] init];
        self.facebookConnect.delegate 	= self;
        
        self.usersController            = [[DWUsersController alloc] init];
        self.usersController.delegate   = self;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.facebookConnect authorize];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWFacebookConnectDelegate

//----------------------------------------------------------------------------------------------------
- (void)fbAuthenticatedWithToken:(NSString *)accessToken {
    
    [self.usersController updateUserHavingID:[DWSession sharedDWSession].currentUser.databaseID 
                     withFacebookAccessToken:accessToken];
}

//----------------------------------------------------------------------------------------------------
- (void)fbAuthenticationFailed {
    NSLog(@"Facebook Authentication Failed - Show an alert");
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWUsersControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)userUpdated:(DWUser *)user {    
    [user destroy];    
    [self.navigationController popViewControllerAnimated:YES];
}

//----------------------------------------------------------------------------------------------------
- (void)userUpdateError:(NSString *)error {
    NSLog(@"Error in User Update - Show an alert");
}

@end
