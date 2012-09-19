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
#import "DWConstants.h"

static NSString* const kImgBottomDrawer         = @"bottom-drawer-trans@2x.png";
static NSString* const kImgStartMineButtonOff   = @"btn-start-off@2x.png";
static NSString* const kImgStartMineButtonOn    = @"btn-start-on@2x.png";


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
        self.navTitleView = [[DWNavigationBarTitleView alloc] initWithFrame:CGRectMake(121,0,76,44)
                                                               andImageName:kNavBarMineLogo];
    
    self.globalFeedViewController.view.frame = CGRectMake(0,0,320,460);
    
    [self.view addSubview:self.globalFeedViewController.view];    
    
    
    UIImageView *topShadowView      = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kImgTopShadow]];
    topShadowView.frame             = CGRectMake(0,0,320,3);
    
    [self.view addSubview:topShadowView];

    [self createFooter];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Private Methods

//----------------------------------------------------------------------------------------------------
- (void)createFooter {
    UIImageView *footerImageView            = [[UIImageView alloc] initWithFrame:CGRectMake(0, 350, 320, 66)];
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
