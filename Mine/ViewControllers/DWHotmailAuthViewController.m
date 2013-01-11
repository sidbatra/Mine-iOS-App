//
//  DWHotmailAuthViewController.m
//  Mine
//
//  Created by Siddharth Batra on 12/21/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWHotmailAuthViewController.h"
#import "DWHotmailController.h"
#import "DWNavigationBarBackButton.h"
#import "DWGUIManager.h"
#import "DWAnalyticsManager.h"
#import "DWSession.h"


static NSString* const kMsgErrorTitle       = @"Error";
static NSString* const kMsgCancelTitle      = @"Dismiss";
static NSString* const kMsgError            = @"Invalid email or password.";



@interface DWHotmailAuthViewController () {
}

- (void)authorize;
- (void)showLoadingState;
- (void)hideLoadingState;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWHotmailAuthViewController

@synthesize hotmailController           = _hotmailController;
@synthesize emailTextField              = _emailTextField;
@synthesize passwordTextField           = _passwordTextField;
@synthesize loadingView                 = _loadingView;
@synthesize delegate                    = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if (self) {
        self.hotmailController = [[DWHotmailController alloc] init];
        self.hotmailController.delegate = self;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem   = [DWNavigationBarBackButton backButtonForNavigationController:self.navigationController];
    self.navigationItem.titleView           = [DWGUIManager navBarTitleViewWithText:@"Hotmail Login"];
    self.navigationItem.rightBarButtonItem  = [DWGUIManager navBarDoneButtonWithTarget:self];
    
    [self.emailTextField becomeFirstResponder];
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Hotmail Connect View"];
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
        [self showLoadingState];
        
        [self.hotmailController validateEmail:self.emailTextField.text
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
#pragma mark DWHotmailControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)hotmailValidationLoaded:(NSNumber *)status {
    
    if(status && [status boolValue] == true) {
        [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Hotmail Auth Accepted"];
        [self.delegate hotmailAuthAccepted];
    }
    else {
        [self hideLoadingState];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kMsgErrorTitle
                                                        message:kMsgError
                                                       delegate:nil
                                              cancelButtonTitle:kMsgCancelTitle
                                              otherButtonTitles:nil];
        [alert show];
        
        [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Hotmail Auth Failed"];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)hotmailValidationLoadError:(NSString *)error {
    [self hideLoadingState];
}


@end
