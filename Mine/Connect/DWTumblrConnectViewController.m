//
//  DWTumblrConnectViewController.m
//  Mine
//
//  Created by Deepak Rao on 8/7/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWTumblrConnectViewController.h"
#import "DWSession.h"

/**
 * Private declarations
 */
@interface DWTumblrConnectViewController () {
    DWTumblrConnect     *_tumblrConnect;
    DWUsersController   *_usersController;
    
    BOOL                _isAwaitingResponse;
}

/**
 * Wrapper for tumblr xAuth
 */
@property (nonatomic,strong) DWTumblrConnect *tumblrConnect;

/**
 * Data controller for the users model.
 */
@property (nonatomic,strong) DWUsersController *usersController;

@end


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTumblrConnectViewController

@synthesize emailTextField              = _emailTextField;
@synthesize passwordTextField           = _passwordTextField;
@synthesize tumblrConnect               = _tumblrConnect;
@synthesize usersController             = _usersController;
@synthesize delegate                    = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if (self) {
        self.tumblrConnect              = [[DWTumblrConnect alloc] init];
        self.tumblrConnect.delegate 	= self;
        
        self.usersController            = [[DWUsersController alloc] init];
        self.usersController.delegate   = self;
        
        _isAwaitingResponse             = NO;
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
#pragma mark UITextFieldDelegate

//----------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    
	if(textField == self.passwordTextField)
        [self.tumblrConnect authorizeWithUsername:self.emailTextField.text 
                                      andPassword:self.passwordTextField.text];    
    
	return YES;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWTumblrConnectDelegate

//----------------------------------------------------------------------------------------------------
- (void)tumblrAuthenticatedWithToken:(NSString *)accessToken 
                           andSecret:(NSString *)secret {
    
    _isAwaitingResponse = YES;
    
    [self.usersController updateUserHavingID:[DWSession sharedDWSession].currentUser.databaseID 
                             withTumblrToken:accessToken 
                             andTumblrSecret:secret];
}

//----------------------------------------------------------------------------------------------------
- (void)tumblrAuthenticationFailed {
    NSLog(@"Tumblr Authentication Failed - Show an alert");
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWUsersControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)userUpdated:(DWUser *)user {
    
    if(_isAwaitingResponse) {
        [self.delegate tumblrConfigured];
        _isAwaitingResponse = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }

    [user destroy];    
}

//----------------------------------------------------------------------------------------------------
- (void)userUpdateError:(NSString *)error {
    NSLog(@"Error in User Update - Show an alert");
}

@end
