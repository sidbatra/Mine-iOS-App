//
//  DWUsersNavigationViewController.m
//  Mine
//
//  Created by Siddharth Batra on 1/2/13.
//  Copyright (c) 2013 Denwen, Inc. All rights reserved.
//

#import "DWUsersNavigationViewController.h"
#import "DWNavigationBar.h"
#import "DWAnalyticsManager.h"
#import "DWUser.h"
#import "DWConstants.h"


@interface DWUsersNavigationViewController () {
    DWUsersViewController       *_usersSearchViewController;
    DWSuggestedUsersViewController *_suggestedUsersViewController;

    DWSearchBar                 *_searchBar;
}

@property (nonatomic,strong) DWUsersViewController *usersSearchViewController;
@property (nonatomic,strong) DWUsersViewController *suggestedUsersViewController;

/**
 * Nav bar search input field for searching users.
 */
@property (nonatomic,strong) DWSearchBar *searchBar;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUsersNavigationViewController

@synthesize usersSearchViewController       = _usersSearchViewController;
@synthesize suggestedUsersViewController    = _suggestedUsersViewController;
@synthesize searchBar                       = _searchBar;
@synthesize delegate                        = _delegate;

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark View Lifecycle

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
    
    [self.navigationController setValue:[[DWNavigationBar alloc] init] forKeyPath:kKeyNavigationBar];
    
    self.navigationItem.title = @"";
    
    
    if(!self.usersSearchViewController) {
        self.usersSearchViewController = [[DWUsersSearchViewController alloc] init];
        self.usersSearchViewController.delegate = self;
        self.usersSearchViewController.view.hidden = YES;

        
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(usersSearchViewControllerTapped)];
        gestureRecognizer.cancelsTouchesInView = NO;
        [self.usersSearchViewController.view addGestureRecognizer:gestureRecognizer];
    }
    
    [self.view addSubview:self.usersSearchViewController.view];
    
    
    if(!self.suggestedUsersViewController) {
        self.suggestedUsersViewController = [[DWSuggestedUsersViewController alloc] init];
        self.suggestedUsersViewController.delegate = self;
        self.suggestedUsersViewController.view.hidden = NO;
        
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(suggestedUsersViewControllerTapped)];
        gestureRecognizer.cancelsTouchesInView = NO;
        [self.suggestedUsersViewController.view addGestureRecognizer:gestureRecognizer];
    }
    
    [self.view addSubview:self.suggestedUsersViewController.view];
    
    
    if(!self.searchBar) {
        self.searchBar                      = [[DWSearchBar alloc] initWithFrame:CGRectMake(0,0,320,44)];
        self.searchBar.minimumQueryLength   = 1;
        self.searchBar.delegate             = self;
    }
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Suggested Users View"];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidAppear:(BOOL)animated {
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWSearchBarDelegate

//----------------------------------------------------------------------------------------------------
- (void)searchCancelled {
    [self.delegate usersNavViewDismiss];
}

//----------------------------------------------------------------------------------------------------
- (void)searchWithQuery:(NSString*)query {
    self.suggestedUsersViewController.view.hidden = YES;
    self.usersSearchViewController.view.hidden = NO;
    
    [(DWUsersSearchViewController*)self.usersSearchViewController loadUsersForQuery:query];
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Users Searched"];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWUsersSearchViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)searchViewInviteFriendClicked {
    [self displayInvite];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UITapGestureRecognizer

//----------------------------------------------------------------------------------------------------
- (void)usersSearchViewControllerTapped {
    [self.searchBar hideKeyboard];
}

//----------------------------------------------------------------------------------------------------
- (void)suggestedUsersViewControllerTapped {
    [self.searchBar hideKeyboard];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UINavigationControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)navigationController:(UINavigationController *)navigationController
	  willShowViewController:(UIViewController *)viewController
					animated:(BOOL)animated {
    
    self.searchBar.hidden = viewController != self;
    
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
    [self.navigationController.navigationBar addSubview:self.searchBar];
}

@end
