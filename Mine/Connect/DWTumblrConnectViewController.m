//
//  DWTumblrConnectViewController.m
//  Mine
//
//  Created by Deepak Rao on 8/7/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWTumblrConnectViewController.h"
#import "DWNavigationBarBackButton.h"
#import "DWGUIManager.h"
#import "DWSession.h"


static NSString* const kMsgErrorTitle       = @"Error";
static NSString* const kMsgCancelTitle      = @"OK";
static NSString* const kMsgError            = @"Incorrect email or password";

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


/**
 * Authorize user's Tumblr account
 */
- (void)authorize;

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

    self.navigationItem.leftBarButtonItem   = [DWNavigationBarBackButton backButtonForNavigationController:self.navigationController];
    self.navigationItem.titleView           = [DWGUIManager navBarTitleViewWithText:@"Tumblr Login"];    
    self.navigationItem.rightBarButtonItem  = [DWGUIManager navBarDoneButtonWithTarget:self];    
    
    [self.emailTextField becomeFirstResponder];
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
    
    if(self.emailTextField.text.length && self.passwordTextField.text.length) {
        [self.tumblrConnect authorizeWithUsername:self.emailTextField.text 
                                      andPassword:self.passwordTextField.text];    
    }
    else {
        NSLog(@"incomplete fields");
    }
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UITextFieldDelegate

//----------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField*)textField {

    if(textField == self.emailTextField)
        [self.passwordTextField becomeFirstResponder];
    
	if(textField == self.passwordTextField)
        [self authorize];
    
	return YES;
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kMsgErrorTitle
                                                    message:kMsgError
                                                   delegate:nil
                                          cancelButtonTitle:kMsgCancelTitle
                                          otherButtonTitles:nil];
    [alert show];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWUsersControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)userUpdated:(DWUser *)user {
    
    if(_isAwaitingResponse) {
        
        SEL sel = @selector(tumblrConfigured);
        
        if([self.delegate respondsToSelector:sel])
            [self.delegate performSelector:sel];
        
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
