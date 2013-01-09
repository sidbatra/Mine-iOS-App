//
//  DWFeedNavigationViewController.m
//  Mine
//
//  Created by Siddharth Batra on 7/25/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWFeedNavigationViewController.h"
#import "DWFeedViewController.h"
#import "DWNavigationBarTitleView.h"
#import "DWAnalyticsManager.h"

#import "DWBackgroundQueue.h"
#import "DWCreatePurchaseBackgroundQueueItem.h"
#import "DWPurchase.h"
#import "DWProduct.h"
#import "DWUser.h"
#import "DWStore.h"

#import "DWConstants.h"


static NSString* const kImgCreationOff    = @"nav-btn-add-off.png";
static NSString* const kImgCreationOn     = @"nav-btn-add-on.png";



@interface DWFeedNavigationViewController () {
    DWFeedViewController        *_feedViewController;
    
    DWNavigationBarTitleView    *_navTitleView;
    DWQueueProgressView         *_queueProgressView;
    DWNavigationBarCountView    *_navNotificationsView;
    
    BOOL    _isProgressBarActive;
}

/**
 * Table view controller for displaying the feed.
 */
@property (nonatomic,strong) DWFeedViewController *feedViewController;

/**
 * Tile view inserted onto the navigation bar.
 */
@property (nonatomic,strong) DWNavigationBarTitleView *navTitleView;

/**
 * Nav bar queue progress view for displaying progress from the background queue.
 */
@property (nonatomic,strong) DWQueueProgressView *queueProgressView;

@property (nonatomic,strong) DWNavigationBarCountView *navNotificationsView;

/**
 * Status of the background progress queue.
 */
@property (nonatomic,assign) BOOL isProgressBarActive;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWFeedNavigationViewController

@synthesize feedViewController          = _feedViewController;
@synthesize navTitleView                = _navTitleView;
@synthesize queueProgressView           = _queueProgressView;
@synthesize navNotificationsView        = _navNotificationsView;
@synthesize isProgressBarActive         = _isProgressBarActive;

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark View Lifecycle

//----------------------------------------------------------------------------------------------------
- (void)loadSideButtons {
    
    if(!self.navNotificationsView) {
        self.navNotificationsView = [[DWNavigationBarCountView alloc] initWithFrame:CGRectMake(0,0,40,30)];
        self.navNotificationsView.delegate = self;
    }
    
    UIBarButtonItem *barButtonitem          = [[UIBarButtonItem alloc] initWithCustomView:self.navNotificationsView];
    self.navigationItem.leftBarButtonItem   = barButtonitem;
    
    
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];

    [button setBackgroundImage:[UIImage imageNamed:kImgCreationOff]
                      forState:UIControlStateNormal];
    
    [button setBackgroundImage:[UIImage imageNamed:kImgCreationOn]
                      forState:UIControlStateHighlighted];
    
	[button addTarget:self
               action:@selector(createButtonClicked)
     forControlEvents:UIControlEventTouchUpInside];
    
	[button setFrame:CGRectMake(0, 0,40,30)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

//----------------------------------------------------------------------------------------------------
- (void)removeSideButtons {
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
        
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(backgroundQueueUpdated:)
                                                 name:kNBackgroundQueueUpdated
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onboardingStarted:)
                                                 name:kNOnboardingStarted
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateNotificationsCount:)
                                                 name:kNUpdateNotificationsCount
                                               object:nil];
    
    
    
    self.navigationItem.title = @"";
    
    if(!self.feedViewController) {
        self.feedViewController = [[DWFeedViewController alloc] init];
        self.feedViewController.delegate = self;
    }
    
    [self.view addSubview:self.feedViewController.view];

    
    if(!self.navTitleView) {
        self.navTitleView =  [DWNavigationBarTitleView logoTitleView];
    }
    
    if(!self.queueProgressView) {    
        self.queueProgressView			= [[DWQueueProgressView alloc] initWithFrame:CGRectMake(60,0,200,44)];
        self.queueProgressView.delegate	= self;
    }
    
    
    [self loadSideButtons];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidAppear:(BOOL)animated {
    [self.feedViewController viewDidAppear:animated];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)backgroundQueueUpdated:(NSNotification*)notification {
    NSDictionary *info = [notification userInfo];
	
	NSInteger totalActive	= [[info objectForKey:kKeyTotalActive] integerValue];
	NSInteger totalFailed	= [[info objectForKey:kKeyTotalFailed] integerValue];
	float totalProgress		= [[info objectForKey:kKeyTotalProgress] floatValue];
	
	
	if(totalActive || totalFailed) {
		
        if(!self.isProgressBarActive) {
            self.isProgressBarActive = YES;
            [self.navTitleView removeFromSuperview];
            [self.navigationController.navigationBar addSubview:self.queueProgressView];
        }
		
		[self.queueProgressView updateDisplayWithTotalActive:totalActive
                                                totalFailed:totalFailed
                                              totalProgress:totalProgress];
	}
	else if(self.isProgressBarActive) {
        self.isProgressBarActive = NO;
        
        [self.queueProgressView removeFromSuperview];
        
        if(self.navigationController.topViewController == self)
            [self.navigationController.navigationBar addSubview:self.navTitleView];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)onboardingStarted:(NSNotification*)notification {
    [self.feedViewController viewDidAppear:NO];
}

//----------------------------------------------------------------------------------------------------
- (void)updateNotificationsCount:(NSNotification*)notification {
    NSDictionary *info = [notification userInfo];

    [self.navNotificationsView setCount:[[info objectForKey:kKeyCount] integerValue]];
}



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWQueueProgressView

//----------------------------------------------------------------------------------------------------
- (void)deleteButtonPressed {
    [[DWBackgroundQueue sharedDWBackgroundQueue] deleteRequests];
}

//----------------------------------------------------------------------------------------------------
- (void)retryButtonPressed {
    [[DWBackgroundQueue sharedDWBackgroundQueue] retryRequests];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UI Events

//----------------------------------------------------------------------------------------------------
- (void)createButtonClicked {
    
    DWCreationNavigationViewController *creationRootViewController = [[DWCreationNavigationViewController alloc] init];
    creationRootViewController.delegate = self;
    
    UINavigationController *creationNavController = [[UINavigationController alloc] initWithRootViewController:creationRootViewController];
    
    [self.customTabBarController presentModalViewController:creationNavController
                                                   animated:NO];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWCreationNavigationViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)dismissCreateView {
    [self.customTabBarController dismissModalViewControllerAnimated:YES];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWNavigationBarCountViewDelegate

//----------------------------------------------------------------------------------------------------
- (void)navBarCountViewButtonClicked {
    DWNotificationsViewController *notificationsViewController = [[DWNotificationsViewController alloc] init];
    notificationsViewController.delegate = self;
    
    [self.navigationController pushViewController:notificationsViewController
                                         animated:NO];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWNotificationsViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)notificationsViewDisplayPurchase:(DWPurchase*)purchase {
    [self displayPurchaseViewForPurchase:purchase
                            loadRemotely:YES];
}

//----------------------------------------------------------------------------------------------------
- (void)notificationsViewDisplayUser:(DWUser *)user {
    [self displayUserProfile:user];
}

//----------------------------------------------------------------------------------------------------
- (void)notificationsViewDisplayUnapprovedPurchases {
    [self displayUnapprovedPurchases:NO];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWFeedViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)feedViewUserClicked:(DWUser *)user {
    [self displayUserProfile:user];
}

//----------------------------------------------------------------------------------------------------
- (void)googleConnectInitiated {
    [self displayGoogleAuth];
}

//----------------------------------------------------------------------------------------------------
- (void)yahooConnectInitiated {
    [self displayYahooAuth];
}

//----------------------------------------------------------------------------------------------------
- (void)hotmailConnectInitiated {
    [self displayHotmailAuth];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWUnapprovedPurchasesViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)unapprovedPurchasesSuccessfullyApproved {
    [self displayShareProfileView:NO];
}

//----------------------------------------------------------------------------------------------------
- (void)unapprovedPurchasesNoPurchasesApproved {
    [self.feedViewController forceRefresh];    
    [self.navigationController popViewControllerAnimated:YES];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWShareProfileViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)shareProfileViewControllerFinished {
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self.feedViewController forceRefresh];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNRequestTabBarIndexChange
                                                        object:nil
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                [NSNumber numberWithInteger:kProfileTabIndex],kKeyTabIndex,
                                                                [NSNumber numberWithInteger:DWTabBarResetTypeRefresh],kKeyResetType,
                                                                nil]];
    
    [self.navigationController popViewControllerAnimated:YES];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UINavigationControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)navigationController:(UINavigationController *)navigationController 
	  willShowViewController:(UIViewController *)viewController
					animated:(BOOL)animated {
    
    [super navigationController:navigationController 
         willShowViewController:viewController 
                       animated:animated];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors

//----------------------------------------------------------------------------------------------------
- (void)willShowOnNav {    
    if(_isProgressBarActive)
        [self.navigationController.navigationBar addSubview:self.queueProgressView];        
    else
        [self.navigationController.navigationBar addSubview:self.navTitleView];
}

//----------------------------------------------------------------------------------------------------
- (void)scrollToTop {
    [self.feedViewController scrollToTop];
}

@end
