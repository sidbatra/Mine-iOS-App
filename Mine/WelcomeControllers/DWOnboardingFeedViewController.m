//
//  DWOnboardingFeedViewController.m
//  Mine
//
//  Created by Deepak Rao on 9/13/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWOnboardingFeedViewController.h"
#import "DWGlobalFeedViewController.h"
#import "DWNavigationBarTitleView.h"
#import "DWAnalyticsManager.h"
#import "DWDevice.h"
#import "DWConstants.h"

static NSString* const kImgBottomDrawer         = @"bottom-drawer-trans.png";
static NSString* const kImgStartMineButtonOff   = @"btn-start-off.png";
static NSString* const kImgStartMineButtonOn    = @"btn-start-on.png";


/**
 * Private declaration
 */
@interface DWOnboardingFeedViewController () {
    DWNavigationBarTitleView        *_navTitleView;    
    DWGlobalFeedViewController      *_globalFeedViewController;
}

/**
 * Tile view inserted onto the navigation bar.
 */
@property (nonatomic,strong) DWNavigationBarTitleView *navTitleView;    

/**
 * Global feed view controller 
 */
@property (nonatomic,strong) DWGlobalFeedViewController *globalFeedViewController;


/**
 * Create a static footer with 'Start your Mine' button
 */
- (void)createFooter;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWOnboardingFeedViewController

@synthesize navTitleView                = _navTitleView;
@synthesize globalFeedViewController    = _globalFeedViewController;

@synthesize delegate                    = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {        
        self.globalFeedViewController = [[DWGlobalFeedViewController alloc] init];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title           = @"";    
    
    if(!self.navTitleView)
        self.navTitleView = [DWNavigationBarTitleView logoTitleView];
        
    [self.view addSubview:self.globalFeedViewController.view];    
    
    
    UIImageView *topShadowView      = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kImgTopShadow]];
    topShadowView.frame             = CGRectMake(0,0,320,3);
    
    [self.view addSubview:topShadowView];

    [self createFooter];
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Welcome View"];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Private Methods

//----------------------------------------------------------------------------------------------------
- (void)createFooter {
    UIImageView *footerImageView            = [[UIImageView alloc] initWithFrame:CGRectMake(
                                                                    0,self.view.frame.size.height - [DWDevice sharedDWDevice].navBarHeight - 66,
                                                                    320,66)];
    
    footerImageView.image                   = [UIImage imageNamed:kImgBottomDrawer];   
    footerImageView.userInteractionEnabled  = YES;
    
    
    UIButton *startMineButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,320,66)];
    
    [startMineButton setBackgroundImage:[UIImage imageNamed:kImgStartMineButtonOff] 
                               forState:UIControlStateNormal];
    
    [startMineButton setBackgroundImage:[UIImage imageNamed:kImgStartMineButtonOn] 
                               forState:UIControlStateHighlighted];    
    
    [startMineButton addTarget:self
                        action:@selector(didTapStartMineButton:)
              forControlEvents:UIControlEventTouchUpInside];
    
    [footerImageView addSubview:startMineButton];
    
    
    [self.view addSubview:footerImageView];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark IBAction

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
- (void)didTapStartMineButton:(UIButton*)button {
    
    SEL sel = @selector(showScreenAfterGlobalFeed);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    [self.delegate performSelector:sel];
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
