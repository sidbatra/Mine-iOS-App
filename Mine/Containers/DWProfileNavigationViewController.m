//
//  DWProfileNavigationViewController.m
//  Mine
//
//  Created by Siddharth Batra on 7/26/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWProfileNavigationViewController.h"

#import "DWProfileViewController.h"
#import "DWNavigationBarTitleView.h"
#import "DWSession.h"
#import "DWConstants.h"


static NSString* const kImgSettingsOff          = @"nav-btn-settings-off.png";
static NSString* const kImgSettingsOn           = @"nav-btn-settings-on.png";
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
    
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];    
    
    [button setBackgroundImage:[UIImage imageNamed:kImgSettingsOff] 
                      forState:UIControlStateNormal];
    
    [button setBackgroundImage:[UIImage imageNamed:kImgSettingsOn] 
                      forState:UIControlStateHighlighted];
    
	[button addTarget:self
               action:@selector(settingsButtonClicked)
     forControlEvents:UIControlEventTouchUpInside];
    
	[button setFrame:CGRectMake(0, 0,40,30)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    
    
    
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
                                                     otherButtonTitles:@"Edit bio",@"About",@"FAQ",nil];
    
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
            NSLog(@"Log OUT");
            break;
        case 1:
            NSLog(@"Edit bio");
            break;
        case 2:
            [self displayExternalURL:[NSString stringWithFormat:@"%@%@%@",kAppProtocol,kAppServer,kAboutURL]];
            break;
        case 3:
            [self displayExternalURL:[NSString stringWithFormat:@"%@%@%@",kAppProtocol,kAppServer,kFAQURL]];
            break;
        default:
            break;
    }    
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
