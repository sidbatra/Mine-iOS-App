//
//  DWFeedNavigationViewController.m
//  Mine
//
//  Created by Siddharth Batra on 7/25/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWFeedNavigationViewController.h"
#import "DWFeedViewController.h"
#import "DWUsersSearchViewController.h"
#import "DWNavigationBarTitleView.h"

#import "DWBackgroundQueue.h"
#import "DWCreatePurchaseBackgroundQueueItem.h"
#import "DWPurchase.h"
#import "DWProduct.h"
#import "DWUser.h"
#import "DWStore.h"

#import "DWConstants.h"


static NSString* const kImgSearchOff    = @"nav-btn-search-off.png";
static NSString* const kImgSearchOn     = @"nav-btn-search-on.png";



@interface DWFeedNavigationViewController () {
    DWFeedViewController        *_feedViewController;
    DWUsersSearchViewController *_usersSearchViewController;
    
    DWNavigationBarTitleView    *_navTitleView;
    DWQueueProgressView         *_queueProgressView;
    DWSearchBar                 *_searchBar;
    
    BOOL    _isProgressBarActive;
}

/**
 * Table view controller for displaying the feed.
 */
@property (nonatomic,strong) DWFeedViewController *feedViewController;

/**
 * Table view for displaying search results.
 */
@property (nonatomic,strong) DWUsersSearchViewController *usersSearchViewController;

/**
 * Tile view inserted onto the navigation bar.
 */
@property (nonatomic,strong) DWNavigationBarTitleView *navTitleView;

/**
 * Nav bar queue progress view for displaying progress from the background queue.
 */
@property (nonatomic,strong) DWQueueProgressView *queueProgressView;

/**
 * Nav bar search input field for searching users.
 */
@property (nonatomic,strong) DWSearchBar *searchBar;

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
@synthesize usersSearchViewController   = _usersSearchViewController;
@synthesize navTitleView                = _navTitleView;
@synthesize queueProgressView           = _queueProgressView;
@synthesize searchBar                   = _searchBar;
@synthesize isProgressBarActive         = _isProgressBarActive;

//----------------------------------------------------------------------------------------------------
- (void)awakeFromNib {
	[super awakeFromNib];	
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(backgroundQueueUpdated:) 
                                                 name:kNBackgroundQueueUpdated
                                               object:nil];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark View Lifecycle

//----------------------------------------------------------------------------------------------------
- (void)loadSideButtons {
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];    

    [button setBackgroundImage:[UIImage imageNamed:kImgSearchOff] 
                      forState:UIControlStateNormal];
    
    [button setBackgroundImage:[UIImage imageNamed:kImgSearchOn] 
                      forState:UIControlStateHighlighted];
    
	[button addTarget:self
               action:@selector(searchButtonClicked)
     forControlEvents:UIControlEventTouchUpInside];
    
	[button setFrame:CGRectMake(0, 0,40,30)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

//----------------------------------------------------------------------------------------------------
- (void)removeSideButtons {
    self.navigationItem.rightBarButtonItem = nil;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
    
    self.navigationItem.title = @"";
    
    if(!self.feedViewController) {
        self.feedViewController = [[DWFeedViewController alloc] init];
        self.feedViewController.delegate = self;
    }
    
    [self.view addSubview:self.feedViewController.view];
    
    
    if(!self.usersSearchViewController) {
        self.usersSearchViewController = [[DWUsersSearchViewController alloc] init];
        self.usersSearchViewController.delegate = self;
        self.usersSearchViewController.view.hidden = YES;
    }
    
    [self.view addSubview:self.usersSearchViewController.view];

    
    if(!self.navTitleView) {
        self.navTitleView =  [[DWNavigationBarTitleView alloc] initWithFrame:CGRectMake(121,0,76,44)
                                                                andImageName:kNavBarMineLogo];
    }
    
    if(!self.queueProgressView) {    
        self.queueProgressView			= [[DWQueueProgressView alloc] initWithFrame:CGRectMake(60,0,200,44)];
        self.queueProgressView.delegate	= self;
    }
    
    if(!self.searchBar) {
        self.searchBar                      = [[DWSearchBar alloc] initWithFrame:CGRectMake(0,0,320,44)];
        self.searchBar.minimumQueryLength   = 1;
        self.searchBar.delegate             = self;
        self.searchBar.hidden               = YES;
    }
    
    [self loadSideButtons];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
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
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWPostProgressViewDelegate

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
- (void)searchButtonClicked {
    //[self.customTabBarController enableFullScreen];
    self.feedViewController.view.hidden             = YES;    
    self.navTitleView.hidden                        = YES;
    self.queueProgressView.hidden                   = YES;
    self.usersSearchViewController.view.hidden      = NO;
    self.searchBar.hidden                           = NO;

    
    [self.searchBar becomeActive];
    
    [self removeSideButtons];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWSearchBarDelegate

//----------------------------------------------------------------------------------------------------
- (void)searchCancelled {
    
    self.usersSearchViewController.view.hidden      = YES;
    self.searchBar.hidden                           = YES;
    self.feedViewController.view.hidden             = NO; 
    self.navTitleView.hidden                        = NO;
    self.queueProgressView.hidden                   = NO;
    
    //[self.customTabBarController disableFullScreen];
    
    [self.usersSearchViewController reset];
    [self.searchBar resignActive];
    
    [self loadSideButtons];
}

//----------------------------------------------------------------------------------------------------
- (void)searchWithQuery:(NSString*)query {
    [self.usersSearchViewController loadUsersForQuery:query];
}




//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UINavigationControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)navigationController:(UINavigationController *)navigationController 
	  willShowViewController:(UIViewController *)viewController
					animated:(BOOL)animated {
    
    self.searchBar.hidden = viewController != self || self.usersSearchViewController.view.hidden;
    
    [super navigationController:navigationController 
         willShowViewController:viewController 
                       animated:animated];
    
    //if (!self.searchViewController.view.hidden) 
    //    [self.customTabBarController enableFullScreen];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors

//----------------------------------------------------------------------------------------------------
- (void)willShowOnNav {
    [self.navigationController.navigationBar addSubview:self.searchBar];
    
    if(_isProgressBarActive)
        [self.navigationController.navigationBar addSubview:self.queueProgressView];        
    else
        [self.navigationController.navigationBar addSubview:self.navTitleView];
}

@end
