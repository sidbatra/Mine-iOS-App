//
//  DWWelcomeNavigationRootViewController.m
//  Mine
//
//  Created by Siddharth Batra on 7/25/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWWelcomeNavigationRootViewController.h"
#import "DWNavigationBarTitleView.h"
#import "DWSuggestion.h"
#import "DWConstants.h"

/**
 * Private declarations
 */
@interface DWWelcomeNavigationRootViewController () {
    DWLoginViewController   *_loginViewController;
    
    DWNavigationBarTitleView *_navTitleView;
}

/**
 * Login view controller
 */
@property (nonatomic,strong) DWLoginViewController *loginViewController;

@property (nonatomic,strong) DWNavigationBarTitleView *navTitleView;



/**
 * End the welcome navigation by firing a notification.
 * It's supposed to be used when a user has successfully finished
 * either a log in or sign up and is now ready to enter the app.
 */
- (void)endWelcomeNavigation;

/**
 * Launch the onboarding flow.
 */
- (void)showOnboardingToUser:(DWUser*)user;

/**
 * Insert the global feed view onto the nav bar.
 */
- (void)showGlobalFeedView;

/**
 * Insert view for inputting more user info on to the nav bar.
 */
- (void)showUserDetailsView;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWWelcomeNavigationRootViewController

@synthesize loginViewController = _loginViewController;
@synthesize navTitleView = _navTitleView;

//----------------------------------------------------------------------------------------------------
- (void)awakeFromNib {
	[super awakeFromNib];	
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Private Methods

//----------------------------------------------------------------------------------------------------
- (void)endWelcomeNavigation {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNWelcomeNavigationFinished 
                                                        object:nil];
}

//----------------------------------------------------------------------------------------------------
- (void)showOnboardingToUser:(DWUser*)user {
    if(!user.email || ![user.email length] || !user.gender || ![user.gender length])
        [self showUserDetailsView];
    else
        [self showGlobalFeedView];
}

//----------------------------------------------------------------------------------------------------
- (void)showGlobalFeedView {
    
    DWOnboardingFeedViewController *onboardingFeedViewController = [[DWOnboardingFeedViewController alloc] init];
    onboardingFeedViewController.delegate = self;
    
    [self.navigationController pushViewController:onboardingFeedViewController 
                                         animated:YES];
}

//----------------------------------------------------------------------------------------------------
- (void)showUserDetailsView {
    DWUserDetailsViewController *userDetailsViewController = [[DWUserDetailsViewController alloc] init];
    userDetailsViewController.delegate = self;
    
    [self.navigationController pushViewController:userDetailsViewController
                                         animated:YES];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark View Lifecycle

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
    
    self.navigationItem.title = @"";
    
    if(!self.loginViewController) {
        self.loginViewController              = [[DWLoginViewController alloc] init];
        self.loginViewController.delegate     = self;
        self.loginViewController.view.frame   = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    [self.view addSubview:self.loginViewController.view];
    
    
    if(!self.navTitleView) {
        self.navTitleView =  [DWNavigationBarTitleView logoTitleView];
    }    
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWLoginViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (UINavigationController*)loginViewNavigationController {
    return self.navigationController;
}

//----------------------------------------------------------------------------------------------------
- (void)userLoggedIn:(DWUser*)user {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNUserLoggedIn
                                                        object:nil
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:user,kKeyUser,nil]];
    
    if (user.purchasesCount) 
        [self endWelcomeNavigation];
    else 
        [self showOnboardingToUser:user];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWUserDetailsViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)userDetailsUpdated {
    [self showGlobalFeedView];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWOnboardingFeedViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)showScreenAfterGlobalFeed {
    
    DWSuggestionsViewController *suggestionsViewController = [[DWSuggestionsViewController alloc] init];
    suggestionsViewController.delegate = self;

    [self.navigationController pushViewController:suggestionsViewController
                                         animated:YES];    
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWSuggestionsViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)suggestionPicked:(NSInteger)suggestionID {
    
    DWCreationViewController *creationViewController = [[DWCreationViewController alloc] initWithSuggestion:[DWSuggestion fetch:suggestionID]];
    creationViewController.delegate = self;
    
    [self.navigationController pushViewController:creationViewController 
                                         animated:YES];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWCreationViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)creationCancelled {
    [self.navigationController popViewControllerAnimated:YES];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWPurchaseInputViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)postPurchase:(DWPurchase *)purchase 
             product:(DWProduct *)product 
           shareToFB:(BOOL)shareToFB 
           shareToTW:(BOOL)shareToTW 
           shareToTB:(BOOL)shareToTB {
    
    [super postPurchase:purchase 
                product:product 
              shareToFB:shareToFB 
              shareToTW:shareToTW 
              shareToTB:shareToTB];
    
    [self endWelcomeNavigation];
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
