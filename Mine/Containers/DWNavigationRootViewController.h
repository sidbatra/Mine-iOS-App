//
//  DWNavigationRootViewController.h
//  Mine
//
//  Created by Siddharth Batra on 7/25/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DWUser;
@class DWPurchase;

/**
 * Base class for navigation root view controllers which are used as
 * sub controllers of the custom tab bar controller.
 */
@interface DWNavigationRootViewController : UIViewController<UINavigationControllerDelegate>

/**
 * Push a user profile onto the nav stack.
 */
- (void)displayUserProfile:(DWUser*)user;

/**
 * Push a comments view onto the nav stack.
 */
- (void)displayCommentsCreateViewForPurchase:(DWPurchase*)purchase
                          withCreationIntent:(BOOL)creationIntent;

@end
