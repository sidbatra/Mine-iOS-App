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
#import "DWAnalyticsManager.h"
#import "DWConstants.h"


static NSString* const kImgInfoOn = @"nav-btn-info-on.png";
static NSString* const kImgInfoOff = @"nav-btn-info-off.png";
static NSString* const kInfoURL = @"/?web_view_mode=true";

/**
 * Private declarations
 */
@interface DWWelcomeNavigationRootViewController () {
    DWLoginViewController   *_loginViewController;
    
    DWNavigationBarTitleView *_navTitleView;
    
    BOOL _onboardingAnnounced;
}

/**
 * Login view controller
 */
@property (nonatomic,strong) DWLoginViewController *loginViewController;

@property (nonatomic,strong) DWNavigationBarTitleView *navTitleView;

@property (nonatomic,assign) BOOL onboardingAnnounced;


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
@synthesize onboardingAnnounced = _onboardingAnnounced;

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
        [self showEmailConnectView];
}

//----------------------------------------------------------------------------------------------------
- (void)showUserDetailsView {
    DWUserDetailsViewController *userDetailsViewController = [[DWUserDetailsViewController alloc] init];
    userDetailsViewController.delegate = self;
    
    [self.navigationController pushViewController:userDetailsViewController
                                         animated:YES];
}

//----------------------------------------------------------------------------------------------------
- (void)showGlobalFeedView {
    
    DWOnboardingFeedViewController *onboardingFeedViewController = [[DWOnboardingFeedViewController alloc] init];
    onboardingFeedViewController.delegate = self;
    
    [self.navigationController pushViewController:onboardingFeedViewController
                                         animated:YES];
}

//----------------------------------------------------------------------------------------------------
- (void)showEmailConnectView {
    
    DWEmailConnectViewController *emailConnectViewController = [[DWEmailConnectViewController alloc] init];
    emailConnectViewController.delegate = self;
    
    [self.navigationController pushViewController:emailConnectViewController
                                         animated:YES];
}

//----------------------------------------------------------------------------------------------------
- (void)showShareProfileView {
    
    DWShareProfileViewController *shareProfileViewController = [[DWShareProfileViewController alloc] init];
    shareProfileViewController.delegate = self;
    
    if(shareProfileViewController.isAnyConnectAvailable) {
        [self.navigationController pushViewController:shareProfileViewController
                                             animated:YES];
    }
    else {
        [self endWelcomeNavigation];
    }
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
    
    
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setBackgroundImage:[UIImage imageNamed:kImgInfoOff]
                      forState:UIControlStateNormal];
    
    [button setBackgroundImage:[UIImage imageNamed:kImgInfoOn]
                      forState:UIControlStateHighlighted];
    
	[button addTarget:self
               action:@selector(infoButtonClicked)
     forControlEvents:UIControlEventTouchUpInside];
    
	[button setFrame:CGRectMake(0,0,40,30)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
}

//----------------------------------------------------------------------------------------------------
- (void)announceOnboarding {
    if(self.onboardingAnnounced)
        return;
    
    self.onboardingAnnounced = YES;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNOnboardingStarted
                                                        object:nil];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UI Events

//----------------------------------------------------------------------------------------------------
- (void)infoButtonClicked {
    [self displayExternalURL:[NSString stringWithFormat:@"%@%@%@",kAppProtocol,kAppServer,kInfoURL]];
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Learn More View"];
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
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationController.navigationBar.hidden = NO;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNUserLoggedIn
                                                        object:nil
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:user,kKeyUser,nil]];
    
    if (user.purchasesCount) {
        [self endWelcomeNavigation];
        [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"User Returned"];
    }
    else {
        [self showOnboardingToUser:user];
        
        [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"User Created"];
    }
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWUserDetailsViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)userDetailsUpdated {
    [self showEmailConnectView];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWOnboardingFeedViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)showScreenAfterGlobalFeed {
    [self showEmailConnectView];
    /*
    DWSuggestionsViewController *suggestionsViewController = [[DWSuggestionsViewController alloc] init];
    suggestionsViewController.delegate = self;

    [self.navigationController pushViewController:suggestionsViewController
                                         animated:YES];    
     */
}



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWEmailConnectViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)emailConnectGoogleAuthInitiated {
    [self displayGoogleAuth];
}

//----------------------------------------------------------------------------------------------------
- (void)emailConnectYahooAuthInitiated {
    [self displayYahooAuth];
}

//----------------------------------------------------------------------------------------------------
- (void)emailConnectHotmailAuthInitiated {
    [self displayHotmailAuth];
}

//----------------------------------------------------------------------------------------------------
- (void)emailConnectSkipped {
    [self endWelcomeNavigation];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWShareProfileViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)shareProfileViewControllerFinished {
    [self endWelcomeNavigation];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWUnapprovedPurchasesViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)unapprovedPurchasesSuccessfullyApproved {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNRequestTabBarIndexChange
                                                        object:nil
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                [NSNumber numberWithInteger:kProfileTabIndex],kKeyTabIndex,
                                                                [NSNumber numberWithInteger:DWTabBarResetTypeNone],kKeyResetType,
                                                                nil]];
    
    [self endWelcomeNavigation];
}

//----------------------------------------------------------------------------------------------------
- (void)unapprovedPurchasesNoPurchasesApproved {
    [self endWelcomeNavigation];
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
    
    [self performSelector:@selector(announceOnboarding)
               withObject:nil
               afterDelay:7];
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
