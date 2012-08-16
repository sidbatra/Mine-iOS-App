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


@class DWUser;
@class DWPurchase;

/**
 * Base class for navigation root view controllers which are used as
 * sub controllers of the custom tab bar controller.
 */
@interface DWNavigationRootViewController : UIViewController<UINavigationControllerDelegate,DWProfileViewControllerDelegate,DWUsersViewControllerDelegate,DWPurchasesViewControllerDelegate,DWCreationViewControllerDelegate,DWPurchaseInputViewControllerDelegate>

/**
 * Push a user profile onto the nav stack.
 */
- (void)displayUserProfile:(DWUser*)user;

/**
 * Display a list of users who've liked the given purchase.
 */
- (void)displayAllLikesForPurchase:(DWPurchase*)purchase;

/**
 * Push a comments view onto the nav stack.
 */
- (void)displayCommentsCreateViewForPurchase:(DWPurchase*)purchase
                          withCreationIntent:(BOOL)creationIntent;

@end
