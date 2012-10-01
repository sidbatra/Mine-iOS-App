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
#import "DWAnalyticsManager.h"
#import "DWConstants.h"

static NSString* const kMsgErrorTitle       = @"Error";
static NSString* const kMsgCancelTitle      = @"Dismiss";
static NSString* const kMsgError            = @"Please check your username and password.";

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

/**
 * Show loading state
 */
- (void)showLoadingState;

/**
 * Hide loading state
 */
- (void)hideLoadingState;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTwitterConnectViewController

@synthesize usernameTextField           = _usernameTextField;
@synthesize passwordTextField           = _passwordTextField;
@synthesize loadingView                 = _loadingView;
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
    
    [self.usernameTextField becomeFirstResponder];
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Twitter Connect View"];        
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
        [self showLoadingState];
        [self.twitterConnect authorizeWithUsername:self.usernameTextField.text 
                                       andPassword:self.passwordTextField.text];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)showLoadingState {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.loadingView.hidden = NO;
}

//----------------------------------------------------------------------------------------------------
- (void)hideLoadingState {
    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.loadingView.hidden = YES;
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

    if(textField == self.usernameTextField)
        [self.passwordTextField becomeFirstResponder];
    
	else if(textField == self.passwordTextField)
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
    [self hideLoadingState];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kMsgErrorTitle
                                                    message:kMsgError
                                                   delegate:nil
                                          cancelButtonTitle:kMsgCancelTitle
                                          otherButtonTitles:nil];
    [alert show];
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Twitter Connect Failed"];    
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWUsersControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)userUpdated:(DWUser *)user {
    
    if(_isAwaitingResponse) {
        
        SEL sel = @selector(twitterConfigured);
        
        if([self.delegate respondsToSelector:sel])
            [self.delegate performSelector:sel];
              
        _isAwaitingResponse = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [user destroy];   
}

//----------------------------------------------------------------------------------------------------
- (void)userUpdateError:(NSString *)error {
    [self hideLoadingState];
    
    if (self.navigationController.topViewController == self)
        [DWGUIManager connectionErrorAlertView];
}

@end
