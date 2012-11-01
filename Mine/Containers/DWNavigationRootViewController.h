//
//  DWNavigationRootViewController.h
//  Mine
//
//  Created by Siddharth Batra on 7/25/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DWProfileViewController.h"
#import "DWUsersViewController.h"
#import "DWPurchasesViewController.h"
#import "DWCreationViewController.h"
#import "DWPurchaseInputViewController.h"
#import "DWInviteViewController.h"
#import "DWTabBarController.h"
#import "DWCommentsCreateViewController.h"
#import "DWGoogleAuthViewController.h"
#import "DWYahooAuthViewController.h"


@class DWUser;
@class DWPurchase;

/**
 * Base class for navigation root view controllers which are used as
 * sub controllers of the custom tab bar controller.
 */
@interface DWNavigationRootViewController : UIViewController<UINavigationControllerDelegate,DWProfileViewControllerDelegate,DWUsersViewControllerDelegate,DWPurchasesViewControllerDelegate,DWCreationViewControllerDelegate,DWPurchaseInputViewControllerDelegate,DWCommentsCreateViewControllerDelegate,DWGoogleAuthViewControllerDelegate,DWYahooAuthViewControllerDelegate> {
    
    __weak DWTabBarController *_customTabBarController;
}

/**
 * Weak referene to the custom tab bar controller in which the container is displayed.
 */
@property (nonatomic,weak) DWTabBarController *customTabBarController;

/**
 * Display invite ui onto the nav stack.
 */
- (void)displayInvite;

/**
 * Display given URL in a UIWebView
 */
- (void)displayExternalURL:(NSString*)url;

/**
 * Push a user profile onto the nav stack.
 */
- (void)displayUserProfile:(DWUser*)user;

/**
 * Display a list of users who've liked the given purchase.
 */
- (void)displayAllLikesForPurchase:(DWPurchase*)purchase loadRemotely:(BOOL)loadRemotely;

/**
 * Push a comments view onto the nav stack.
 */
- (void)displayCommentsCreateViewForPurchase:(DWPurchase*)purchase
                          withCreationIntent:(BOOL)creationIntent
                                loadRemotely:(BOOL)loadRemotely;

/**
 * Display purchase view with an option to remote the purchase remotely.
 */
- (void)displayPurchaseViewForPurchase:(DWPurchase*)purchase
                          loadRemotely:(BOOL)loadRemotely;


- (void)displayGoogleAuth;
- (void)displayYahooAuth;

@end
