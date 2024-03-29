//
//  DWFacebookConnectViewController.m
//  Mine
//
//  Created by Deepak Rao on 8/7/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWFacebookConnectViewController.h"
#import "DWAnalyticsManager.h"
#import "DWNavigationBarBackButton.h"
#import "DWGUIManager.h"
#import "DWSession.h"
#import "DWConstants.h"

static NSString* const kMsgErrorTitle       = @"Error";
static NSString* const kMsgCancelTitle      = @"Dismiss";
static NSString* const kMsgError            = @"Mine needs to access your basic Facebook information to proceed. Please enable permissions and continue.";

/**
 * Private declarations
 */
@interface DWFacebookConnectViewController () {
    DWFacebookConnect   *_tumblrConnect;
    DWUsersController   *_usersController;
    
    BOOL                _isAwaitingResponse;
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
@synthesize delegate                    = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if (self) {
        self.facebookConnect            = [[DWFacebookConnect alloc] init];
        self.facebookConnect.delegate 	= self;
        
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
    self.navigationItem.titleView           = [DWGUIManager navBarTitleViewWithText:@"Facebook Login"];
    
    [self.facebookConnect authorizeRead];
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Facebook Connect View"];
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
- (void)fbReadAuthenticatedWithToken:(NSString *)accessToken {
    [self.facebookConnect authorizeWrite];
}

//----------------------------------------------------------------------------------------------------
- (void)fbWriteAuthenticatedWithToken:(NSString *)accessToken {
    
    _isAwaitingResponse = YES;
    
    [self.usersController updateUserHavingID:[DWSession sharedDWSession].currentUser.databaseID
                     withFacebookAccessToken:accessToken];
}

//----------------------------------------------------------------------------------------------------
- (void)fbAuthenticationFailed {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kMsgErrorTitle
                                                    message:kMsgError
                                                   delegate:self
                                          cancelButtonTitle:kMsgCancelTitle
                                          otherButtonTitles:nil];
    [alert show];
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Facebook Connect Failed"];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWUsersControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)userUpdated:(DWUser *)user {    
    
    if(_isAwaitingResponse) {
        
        SEL sel = @selector(facebookConfigured);
        
        if([self.delegate respondsToSelector:sel])
            [self.delegate performSelector:sel];
        
        _isAwaitingResponse = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }

    [user destroy];    
}

//----------------------------------------------------------------------------------------------------
- (void)userUpdateError:(NSString *)error {
    
    if (self.navigationController.topViewController == self)
        [DWGUIManager connectionErrorAlertViewWithDelegate:self];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UIAlertViewDelegate

//----------------------------------------------------------------------------------------------------
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
