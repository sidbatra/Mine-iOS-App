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


static NSString* const kImgSettingsOff    = @"nav-btn-settings-off.png";
static NSString* const kImgSettingsOn     = @"nav-btn-settings-on.png";



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
