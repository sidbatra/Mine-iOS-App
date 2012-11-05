//
//  DWNavigationRootViewController.m
//  Mine
//
//  Created by Siddharth Batra on 7/25/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWNavigationRootViewController.h"
#import "DWLikersViewController.h"
#import "DWFollowersViewController.h"
#import "DWIFollowersViewController.h"
#import "DWPurchaseViewController.h"
#import "DWCreatePurchaseBackgroundQueueItem.h"
#import "DWBackgroundQueue.h"
#import "DWWebViewController.h"

#import "DWPurchase.h"
#import "DWProduct.h"
#import "DWSetting.h"
#import "DWSession.h"

/**
 * Private declarations
 */
@interface DWNavigationRootViewController ()

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWNavigationRootViewController

@synthesize customTabBarController = _customTabBarController;

//----------------------------------------------------------------------------------------------------
- (void)awakeFromNib {
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.delegate = self;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
}

//----------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav stack helpers

//----------------------------------------------------------------------------------------------------
- (void)displayUserProfile:(DWUser*)user {
    DWProfileViewController *profileViewController = [[DWProfileViewController alloc] init];
    [profileViewController applyUser:user];
    profileViewController.delegate = self;
    
    [self.navigationController pushViewController:profileViewController
                                         animated:YES];
}

//----------------------------------------------------------------------------------------------------
- (void)displayAllLikesForPurchase:(DWPurchase*)purchase loadRemotely:(BOOL)loadRemotely {
    DWLikersViewController *likersViewController = [[DWLikersViewController alloc] initWithPurhcase:purchase
                                                                                       loadRemotely:loadRemotely];
    likersViewController.delegate = self;
    
    [self.navigationController pushViewController:likersViewController
                                         animated:YES];
}

//----------------------------------------------------------------------------------------------------
- (void)displayCommentsCreateViewForPurchase:(DWPurchase*)purchase 
                          withCreationIntent:(BOOL)creationIntent
                                loadRemotely:(BOOL)loadRemotely {
    
    DWCommentsCreateViewController *commentsViewController = [[DWCommentsCreateViewController alloc] initWithPurchase:purchase
                                                                                                   withCreationIntent:creationIntent
                                                                                                         loadRemotely:loadRemotely];
    commentsViewController.delegate = self;
    
    [self.navigationController pushViewController:commentsViewController 
                                         animated:YES];
}

//----------------------------------------------------------------------------------------------------
- (void)displayPurchaseViewForPurchase:(DWPurchase*)purchase
                          loadRemotely:(BOOL)loadRemotely {
    
    DWPurchaseViewController *purchaseViewController = [[DWPurchaseViewController alloc] initWithPurhcase:purchase
                                                                                             loadRemotely:loadRemotely];
    purchaseViewController.delegate = self;
    
    [self.navigationController pushViewController:purchaseViewController 
                                         animated:YES];
}

//----------------------------------------------------------------------------------------------------
- (void)displayExternalURL:(NSString*)url {

    DWWebViewController *webViewController = [[DWWebViewController alloc] initWithURL:url];
    
    [self.navigationController pushViewController:webViewController
                                         animated:YES];
}

//----------------------------------------------------------------------------------------------------
- (void)displayFollowersForUser:(DWUser*)user {
    
    DWFollowersViewController *followersViewController = [[DWFollowersViewController alloc] initWithUser:user];
    followersViewController.delegate = self;
    
    [self.navigationController pushViewController:followersViewController
                                         animated:YES];
}

//----------------------------------------------------------------------------------------------------
- (void)displayIfollowersForUser:(DWUser*)user {
    
    DWIFollowersViewController *ifollowersViewController = [[DWIFollowersViewController alloc] initWithUser:user];
    ifollowersViewController.delegate = self;
    
    [self.navigationController pushViewController:ifollowersViewController
                                         animated:YES];
}

//----------------------------------------------------------------------------------------------------
- (void)displayInvite {
    
    DWInviteViewController *inviteViewController = [[DWInviteViewController alloc] init];
    
    [self.navigationController pushViewController:inviteViewController
                                         animated:YES];
}
//----------------------------------------------------------------------------------------------------
- (void)displayGoogleAuth {
    
    DWGoogleAuthViewController *googleAuthViewController = [[DWGoogleAuthViewController alloc] init];
    
    googleAuthViewController.delegate = self;
    
    [self.navigationController pushViewController:googleAuthViewController
                                         animated:NO];
}

//----------------------------------------------------------------------------------------------------
- (void)displayYahooAuth {
    
    DWYahooAuthViewController *yahooAuthViewController = [[DWYahooAuthViewController alloc] init];
    
    yahooAuthViewController.delegate = self;
    
    [self.navigationController pushViewController:yahooAuthViewController
                                         animated:NO];
}

//----------------------------------------------------------------------------------------------------
- (void)displayUnapprovedPurchases:(BOOL)isLive {
    DWUnapprovedPurchasesViewController *unapprovedPurchasesViewController = [[DWUnapprovedPurchasesViewController alloc] initWithModeIsLive:isLive];
    
    unapprovedPurchasesViewController.delegate = self;
    
    [self.navigationController pushViewController:unapprovedPurchasesViewController
                                         animated:YES];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWProfileViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)profileViewPurchaseClicked:(DWPurchase *)purchase {
    [self displayPurchaseViewForPurchase:purchase
                            loadRemotely:NO];
}

//----------------------------------------------------------------------------------------------------
- (void)profileViewPurchaseURLClicked:(DWPurchase *)purchase {
    [self displayExternalURL:purchase.sourceURL];
}

//----------------------------------------------------------------------------------------------------
- (void)profileViewFollowingClickedForUser:(DWUser *)user {
    [self displayIfollowersForUser:user];
}

//----------------------------------------------------------------------------------------------------
- (void)profileViewFollowersClickedForUser:(DWUser *)user {
    [self displayFollowersForUser:user];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWUsersViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)usersViewUserClicked:(DWUser *)user {
    [self displayUserProfile:user];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWPurchasesViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)purchaseViewURLClicked:(DWPurchase *)purchase {
    [self displayExternalURL:purchase.sourceURL];
}

//----------------------------------------------------------------------------------------------------
- (void)purchasesViewUserClicked:(DWUser *)user {
    [self displayUserProfile:user];
}

//----------------------------------------------------------------------------------------------------
- (void)purchasesViewAllLikesClickedForPurchase:(DWPurchase *)purchase {
    [self displayAllLikesForPurchase:purchase
                        loadRemotely:NO];
}

//----------------------------------------------------------------------------------------------------
- (void)purchasesViewCommentClickedForPurchase:(DWPurchase *)purchase 
                            withCreationIntent:(NSNumber *)creationIntent {
    
    [self displayCommentsCreateViewForPurchase:purchase
                            withCreationIntent:[creationIntent boolValue]
                                  loadRemotely:NO];
}

//----------------------------------------------------------------------------------------------------
- (UIViewController*)tabControllerForPurchasesView {
    return self.customTabBarController;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWCreationViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)productSelected:(DWProduct *)product 
            forPurchase:(DWPurchase *)purchase {
    
    DWPurchaseInputViewController *purchaseInputViewController = [[DWPurchaseInputViewController alloc] initWithProduct:product 
                                                                                                            andPurchase:purchase];
    purchaseInputViewController.delegate = self;
    
    [self.navigationController pushViewController:purchaseInputViewController 
                                         animated:YES];
}

//----------------------------------------------------------------------------------------------------
- (void)creationCancelled {
    
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
    
    DWCreatePurchaseBackgroundQueueItem *item = [[DWCreatePurchaseBackgroundQueueItem alloc] initWithPurchase:purchase 
                                                                                                      product:product
                                                                                                    shareToFB:shareToFB
                                                                                                    shareToTW:shareToTW
                                                                                                    shareToTB:shareToTB];
    
    [[DWBackgroundQueue sharedDWBackgroundQueue] performSelector:@selector(addQueueItem:)      
                                                      withObject:item];
        
    [DWSession sharedDWSession].currentUser.setting.shareToFacebook = shareToFB;
    [DWSession sharedDWSession].currentUser.setting.shareToTwitter  = shareToTW;
    [DWSession sharedDWSession].currentUser.setting.shareToTumblr   = shareToTB;    
    
    [[DWSession sharedDWSession] update];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWCreationViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)commentsCreateViewUserClicked:(DWUser *)user {
    [self displayUserProfile:user];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWGoogleAuthViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)googleAuthAccepted {
}

//----------------------------------------------------------------------------------------------------
- (void)googleAuthRejected {
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWYahooAuthViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)yahooAuthAccepted {
}

//----------------------------------------------------------------------------------------------------
- (void)yahooAuthRejected {
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWUnapprovedPurchasesViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)unapprovedPurchasesSuccessfullyApproved {
}

//----------------------------------------------------------------------------------------------------
- (void)unapprovedPurchasesNoPurchasesApproved {
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UINavigationControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)navigationController:(UINavigationController *)navigationController 
	  willShowViewController:(UIViewController *)viewController
					animated:(BOOL)animated {
        
	for (UIView *view in [self.navigationController.navigationBar subviews]) 
		if ([view respondsToSelector:@selector(shouldBeRemovedFromNav)]) 
            [view removeFromSuperview];
    
    
    if ([viewController respondsToSelector:@selector(willShowOnNav)])
        [viewController performSelector:@selector(willShowOnNav)];
    
    
    if ([viewController respondsToSelector:@selector(requiresFullScreenMode)])
        [self.customTabBarController enableFullScreen];
    else
        [self.customTabBarController disableFullScreen];
    
    if ([viewController respondsToSelector:@selector(hideTopShadowOnTabBar)])
        [self.customTabBarController hideTopShadowView]; 	
    else
        [self.customTabBarController showTopShadowView];
}


@end
