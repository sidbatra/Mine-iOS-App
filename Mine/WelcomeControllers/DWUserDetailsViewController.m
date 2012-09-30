//
//  DWUserDetailsViewController.m
//  Mine
//
//  Created by Siddharth Batra on 8/27/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWUserDetailsViewController.h"
#import "DWGUIManager.h"
#import "DWAnalyticsManager.h"
#import "DWSession.h"
#import "DWConstants.h"


static NSString* const kExampleText = @"Example: '%@ bought %@ iPhone 5...'";

/**
 *
 */
@interface DWUserDetailsViewController() {
    DWUsersController   *_usersController;
    DWSessionController *_sessionController;
    
    NSInteger   _selectedButtonIndex;
    NSArray     *_genderDataSource;
    
    BOOL        _isAwaitingResponse;
}

@property (nonatomic,strong) DWUsersController *usersController;
@property (nonatomic,strong) DWSessionController *sessionController;


/**
 * Selected Button Index
 */
@property (nonatomic,assign) NSInteger selectedButtonIndex;

/**
 * Available options for the gender ui element.
 */
@property (nonatomic,strong) NSArray *genderDataSource;


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
@implementation DWUserDetailsViewController

@synthesize usersController         = _usersController;
@synthesize sessionController       = _sessionController;
@synthesize selectedButtonIndex     = _selectedButtonIndex;
@synthesize genderDataSource        = _genderDataSource;
@synthesize titleLabel              = _titleLabel;
@synthesize exampleLabel            = _exampleLabel;
@synthesize emailTextField          = _emailTextField;
@synthesize maleButton              = _maleButton;
@synthesize femaleButton            = _femaleButton;
@synthesize loadingView             = _loadingView;
@synthesize delegate                = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if (self) {
        self.usersController = [[DWUsersController alloc] init];
        self.usersController.delegate = self;
        
        self.genderDataSource   = [NSArray arrayWithObjects:@"male",@"female", nil];
        _isAwaitingResponse     = NO;        
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView           = [DWGUIManager navBarTitleViewWithText:@"New Account"];
    self.navigationItem.rightBarButtonItem  = [DWGUIManager navBarNextButtonWithTarget:self];
    self.navigationItem.hidesBackButton     = YES;
    
    self.titleLabel.text    = [NSString stringWithFormat:@"Welcome %@!",[DWSession sharedDWSession].currentUser.firstName];
    self.exampleLabel.text  = [NSString stringWithFormat:kExampleText,[DWSession sharedDWSession].currentUser.firstName,@"his"];
    
    [self.emailTextField becomeFirstResponder];
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Welcome Info"];
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
- (void)initiateLogout {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNUserLoggedOut
                                                        object:nil
                                                      userInfo:nil];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark IBActions

//----------------------------------------------------------------------------------------------------
- (void)maleButtonClicked:(id)sender {
    
    if(!self.maleButton.isSelected) {
        self.selectedButtonIndex    = 0;
        self.maleButton.selected    = YES;
        self.femaleButton.selected  = NO;
        
        self.exampleLabel.text      = [NSString stringWithFormat:kExampleText,[DWSession sharedDWSession].currentUser.firstName,@"his"];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)femaleButtonClicked:(id)sender {
    
    if(!self.femaleButton.isSelected) {
        self.selectedButtonIndex    = 1;
        self.femaleButton.selected  = YES;
        self.maleButton.selected    = NO;
        
        self.exampleLabel.text      = [NSString stringWithFormat:kExampleText,[DWSession sharedDWSession].currentUser.firstName,@"her"];        
    }
}

//----------------------------------------------------------------------------------------------------
- (void)nextButtonClicked {
    
    if(!self.emailTextField.text.length)
        return;
    
    [self showLoadingState];
    
    _isAwaitingResponse = YES;
    
    [self.usersController updateUserHavingID:[DWSession sharedDWSession].currentUser.databaseID
                                   withEmail:self.emailTextField.text
                                  withGender:[self.genderDataSource objectAtIndex:self.selectedButtonIndex]];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWUsersControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)userUpdated:(DWUser *)user {
    
    if (_isAwaitingResponse) {
        _isAwaitingResponse = NO;
        
        
        if([user.email isEqualToString:self.emailTextField.text]) {
            [self.delegate userDetailsUpdated];
        }
        else {
            [self hideLoadingState];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Sorry, this email address is being used by another user. If you previously signed up with Facebook, sign out and sign in with Facebook."
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Sign Out",@"Cancel", nil];
            [alert show];
        }
    }
    
    [user destroy];
}

//----------------------------------------------------------------------------------------------------
- (void)userUpdateError:(NSString *)error {
    [self hideLoadingState];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UIAlertViewDelegate

//----------------------------------------------------------------------------------------------------
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0) {
        [self showLoadingState];
        
        if(!self.sessionController) {
            self.sessionController = [[DWSessionController alloc] init];
            self.sessionController.delegate = self;
        }
        
        [self.sessionController destroyForever];
    }
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWSessionController 

//----------------------------------------------------------------------------------------------------
- (void)sessionDestroyed {
    [self initiateLogout];
}

//----------------------------------------------------------------------------------------------------
- (void)sessionDestroyError:(NSString *)error {
    [self initiateLogout];
}

@end


