//
//  DWProfileNavigationViewController.m
//  Mine
//
//  Created by Siddharth Batra on 7/26/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWProfileNavigationViewController.h"

#import "DWProfileViewController.h"
#import "DWEditBylineViewController.h"
#import "DWNavigationBarTitleView.h"
#import "DWAnalyticsManager.h"
#import "DWSession.h"
#import "DWConstants.h"


static NSString* const kImgSettingsOff          = @"nav-btn-settings-off.png";
static NSString* const kImgSettingsOn           = @"nav-btn-settings-on.png";
static NSString* const kImgInviteOff            = @"nav-btn-invite-off.png";
static NSString* const kImgInviteOn             = @"nav-btn-invite-on.png";
static NSString* const kAboutURL                = @"/about?web_view_mode=true";
static NSString* const kFAQURL                  = @"/faq?web_view_mode=true";
static NSInteger const kSettingsActionSheetTag  = -1;


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@interface DWProfileNavigationViewController() {
    DWProfileViewController *_profileViewController;
    
    DWNavigationBarTitleView *_navTitleView;
}

/**
 * Table view controller for displaying the profile.
 */
@property (nonatomic,strong) DWProfileViewController *profileViewController;

/**
 * Tile view inserted onto the navigation bar.
 */
@property (nonatomic,strong) DWNavigationBarTitleView *navTitleView;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWProfileNavigationViewController

@synthesize profileViewController   = _profileViewController;
@synthesize navTitleView            = _navTitleView;

//----------------------------------------------------------------------------------------------------
- (void)awakeFromNib {
	[super awakeFromNib];	
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark View Lifecycle

//----------------------------------------------------------------------------------------------------
- (void)loadSideButtons {
    
    UIButton *settingsButton =  [UIButton buttonWithType:UIButtonTypeCustom];    
    
    [settingsButton setBackgroundImage:[UIImage imageNamed:kImgSettingsOff] 
                      forState:UIControlStateNormal];
    
    [settingsButton setBackgroundImage:[UIImage imageNamed:kImgSettingsOn] 
                      forState:UIControlStateHighlighted];
    
	[settingsButton addTarget:self
               action:@selector(settingsButtonClicked)
     forControlEvents:UIControlEventTouchUpInside];
    
	[settingsButton setFrame:CGRectMake(0, 0,40,30)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];    
    
    
    
    UIButton *inviteButton =  [UIButton buttonWithType:UIButtonTypeCustom];    
    
    [inviteButton setBackgroundImage:[UIImage imageNamed:kImgInviteOff] 
                            forState:UIControlStateNormal];
    
    [inviteButton setBackgroundImage:[UIImage imageNamed:kImgInviteOn] 
                            forState:UIControlStateHighlighted];
    
	[inviteButton addTarget:self
                     action:@selector(inviteButtonClicked)
           forControlEvents:UIControlEventTouchUpInside];
    
	[inviteButton setFrame:CGRectMake(0,0,55,30)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:inviteButton];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
    
    self.navigationItem.title = @"";
        
    if(!self.profileViewController) {
        self.profileViewController = [[DWProfileViewController alloc] initWithUser:[DWSession sharedDWSession].currentUser];
        self.profileViewController.delegate = self;
    }
    
    if(!self.navTitleView) {
        self.navTitleView = [DWNavigationBarTitleView logoTitleView];
    }

    [self loadSideButtons];  
    
    [self.view addSubview:self.profileViewController.view];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UI Events

//----------------------------------------------------------------------------------------------------
- (void)settingsButtonClicked {
    UIActionSheet *actionSheet  = [[UIActionSheet alloc] initWithTitle:nil 
                                                              delegate:self 
                                                     cancelButtonTitle:@"Cancel"
                                                destructiveButtonTitle:@"Log Out"
                                                     otherButtonTitles:@"Edit Bio",@"About",@"FAQ",nil];
    
    actionSheet.tag = kSettingsActionSheetTag;
    
    [actionSheet showInView:self.customTabBarController.view];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UIActionSheet Delegate

//----------------------------------------------------------------------------------------------------
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {	
	
    if (actionSheet.tag != kSettingsActionSheetTag)
        return;
                
    switch(buttonIndex) {
        case 0:
            [[NSNotificationCenter defaultCenter] postNotificationName:kNUserLoggedOut
                                                                object:nil
                                                              userInfo:nil];
            
            [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"User Logged Out"];
            break;
            
        case 1: {
            DWEditBylineViewController *editBylineViewController = [[DWEditBylineViewController alloc] init];
            [self.navigationController pushViewController:editBylineViewController
                                                 animated:YES];
            
            break;
        }
        case 2:
            [self displayExternalURL:[NSString stringWithFormat:@"%@%@%@",kAppProtocol,kAppServer,kAboutURL]];
            
            [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"About View"];
            break;
            
        case 3:
            [self displayExternalURL:[NSString stringWithFormat:@"%@%@%@",kAppProtocol,kAppServer,kFAQURL]];
            
            [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"FAQ View"];
            break;
        default:
            break;
    }    
}

//----------------------------------------------------------------------------------------------------
- (void)inviteButtonClicked {
    [self displayInvite];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors

//----------------------------------------------------------------------------------------------------
- (void)willShowOnNav {
    [self.navigationController.navigationBar addSubview:self.navTitleView];
}

@end
