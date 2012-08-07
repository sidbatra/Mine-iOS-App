//
//  DWTwitterConnectViewController.m
//  Mine
//
//  Created by Deepak Rao on 8/6/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWTwitterConnectViewController.h"
#import "DWSession.h"

/**
 * Private declarations
 */
@interface DWTwitterConnectViewController () {
    DWTwitterConnect    *_twitterConnect;
    DWUsersController   *_usersController;
}

/**
 * Wrapper for twitter xAuth
 */
@property (nonatomic,strong) DWTwitterConnect *twitterConnect;

/**
 * Data controller for the users model.
 */
@property (nonatomic,strong) DWUsersController *usersController;

@end


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTwitterConnectViewController

@synthesize usernameTextField           = _usernameTextField;
@synthesize passwordTextField           = _passwordTextField;
@synthesize twitterConnect              = _twitterConnect;
@synthesize usersController             = _usersController;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if (self) {
        self.twitterConnect             = [[DWTwitterConnect alloc] init];
        self.twitterConnect.delegate 	= self;
        
        self.usersController            = [[DWUsersController alloc] init];
        self.usersController.delegate   = self;
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
        [self.twitterConnect authorizeWithUsername:self.usernameTextField.text 
                                       andPassword:self.passwordTextField.text];
    
	return YES;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWTwitterConnectDelegate

//----------------------------------------------------------------------------------------------------
- (void)twAuthenticatedWithToken:(NSString *)token 
                       andSecret:(NSString *)secret {
    
    [self.usersController updateUserHavingID:[DWSession sharedDWSession].currentUser.databaseID 
                            withTwitterToken:token 
                            andTwitterSecret:secret];
}

//----------------------------------------------------------------------------------------------------
- (void)twAuthenticationFailed {
    NSLog(@"Twitter Authentication Failed - Show an alert");
}

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWUsersControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)userUpdated:(DWUser *)user {
    [[DWSession sharedDWSession] update];
    [user destroy];
    
    [self.navigationController popViewControllerAnimated:YES];
}

//----------------------------------------------------------------------------------------------------
- (void)userUpdateError:(NSString *)error {
    NSLog(@"Error in User Update - Show an alert");
}

@end
