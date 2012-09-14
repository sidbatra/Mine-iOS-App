//
//  DWWelcomeNavigationRootViewController.m
//  Mine
//
//  Created by Siddharth Batra on 7/25/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWWelcomeNavigationRootViewController.h"
#import "DWConstants.h"

/**
 * Private declarations
 */
@interface DWWelcomeNavigationRootViewController () {
    DWLoginViewController   *_loginViewController;
}

/**
 * Login view controller
 */
@property (nonatomic,strong) DWLoginViewController *loginViewController;

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
    
    self.navigationItem.title = @"Onboarding";
    
    if(!self.loginViewController) {
        self.loginViewController              = [[DWLoginViewController alloc] init];
        self.loginViewController.delegate     = self;
    }
    
    [self.view addSubview:self.loginViewController.view];
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
    
    DWCreationViewController *creationViewController = [[DWCreationViewController alloc] init];
    creationViewController.delegate = self;
    
    [self.navigationController pushViewController:creationViewController 
                                         animated:YES];
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

@end
