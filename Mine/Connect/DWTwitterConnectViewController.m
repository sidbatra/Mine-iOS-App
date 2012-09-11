//
//  DWTwitterConnectViewController.m
//  Mine
//
//  Created by Deepak Rao on 8/6/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWTwitterConnectViewController.h"
#import "DWNavigationBarBackButton.h"
#import "DWGUIManager.h"
#import "DWSession.h"
#import "DWConstants.h"

/**
 * Private declarations
 */
@interface DWTwitterConnectViewController () {
    DWTwitterConnect    *_twitterConnect;
    DWUsersController   *_usersController;
    
    BOOL                _isAwaitingResponse;
}

/**
 * Wrapper for twitter xAuth
 */
@property (nonatomic,strong) DWTwitterConnect *twitterConnect;

/**
 * Data controller for the users model.
 */
@property (nonatomic,strong) DWUsersController *usersController;


/**
 * Authorize user's Twitter account
 */
- (void)authorize;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTwitterConnectViewController

@synthesize usernameTextField           = _usernameTextField;
@synthesize passwordTextField           = _passwordTextField;
@synthesize twitterConnect              = _twitterConnect;
@synthesize usersController             = _usersController;
@synthesize updateCurrentUser           = _updateCurrentUser;
@synthesize delegate                    = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if (self) {
        self.twitterConnect             = [[DWTwitterConnect alloc] init];
        self.twitterConnect.delegate 	= self;
        
        self.usersController            = [[DWUsersController alloc] init];
        self.usersController.delegate   = self;
        
        _isAwaitingResponse             = NO;  
        self.updateCurrentUser          = YES;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem   = [DWNavigationBarBackButton backButtonForNavigationController:self.navigationController];
    self.navigationItem.titleView           = [DWGUIManager navBarTitleViewWithText:@"Twitter Login"];    
    self.navigationItem.rightBarButtonItem  = [DWGUIManager navBarDoneButtonWithTarget:self];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Private Methods

//----------------------------------------------------------------------------------------------------
- (void)authorize {
    
    if (self.usernameTextField.text.length && self.passwordTextField.text.length) {        
        [self.twitterConnect authorizeWithUsername:self.usernameTextField.text 
                                       andPassword:self.passwordTextField.text];   
    }
    else {
        NSLog(@"incomplete fields");
    }
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark IBActions

//----------------------------------------------------------------------------------------------------
- (void)doneButtonClicked {
    [self authorize];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UITextFieldDelegate

//----------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    
	if(textField == self.passwordTextField)
        [self authorize];
    
	return YES;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWTwitterConnectDelegate

//----------------------------------------------------------------------------------------------------
- (void)twAuthenticatedWithToken:(NSString *)token 
                       andSecret:(NSString *)secret {
    
    SEL sel = @selector(twitterAuthorizedWithAccessToken:andAccessTokenSecret:);
    
    if([self.delegate respondsToSelector:sel])
        [self.delegate performSelector:sel 
                            withObject:token
                            withObject:secret];
    
    
    if(self.updateCurrentUser) {
        _isAwaitingResponse = YES;
        
        [self.usersController updateUserHavingID:[DWSession sharedDWSession].currentUser.databaseID 
                                withTwitterToken:token 
                                andTwitterSecret:secret];
    }
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
    
    if(_isAwaitingResponse) {
        [self.delegate twitterConfigured];            
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
