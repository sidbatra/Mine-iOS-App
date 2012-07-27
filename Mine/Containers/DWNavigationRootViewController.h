//
//  DWNavigationRootViewController.h
//  Mine
//
//  Created by Siddharth Batra on 7/25/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DWUser;

/**
 * Base class for navigation root view controllers which are used as
 * sub controllers of the custom tab bar controller.
 */
@interface DWNavigationRootViewController : UIViewController<UINavigationControllerDelegate>

- (void)displayUserProfile:(DWUser*)user;

@end
