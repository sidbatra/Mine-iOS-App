//
//  DWFacebookConnectViewController.m
//  Mine
//
//  Created by Deepak Rao on 8/7/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWFacebookConnectViewController.h"
#import "DWAnalyticsManager.h"
#import "DWSession.h"
#import "DWConstants.h"

static NSString* const kMsgErrorTitle       = @"Error";
static NSString* const kMsgCancelTitle      = @"OK";
static NSString* const kMsgError            = @"Error connecting with Facebook";

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
    
    [self.facebookConnect authorize];
    
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
- (void)fbAuthenticatedWithToken:(NSString *)accessToken {

    _isAwaitingResponse = YES;
    
    [self.usersController updateUserHavingID:[DWSession sharedDWSession].currentUser.databaseID 
                     withFacebookAccessToken:accessToken];
}

//----------------------------------------------------------------------------------------------------
- (void)fbAuthenticationFailed {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kMsgErrorTitle
                                                    message:kMsgError
                                                   delegate:nil
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
    DWError(@"Error in User Update - Show an alert");
}

@end
