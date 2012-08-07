//
//  DWTwitterConnectViewController.h
//  Mine
//
//  Created by Deepak Rao on 8/6/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DWTwitterConnect.h"
#import "DWUsersController.h"

@protocol DWTwitterConnectViewControllerDelegate;

@interface DWTwitterConnectViewController : UIViewController<UITextFieldDelegate,DWTwitterConnectDelegate,DWUsersControllerDelegate> {
    UITextField         *_usernameTextField;
    UITextField         *_passwordTextField;
    
    __weak id<DWTwitterConnectViewControllerDelegate,NSObject> _delegate;

}

/**
 * IBOutlet properties
 */
@property (nonatomic) IBOutlet UITextField *usernameTextField;
@property (nonatomic) IBOutlet UITextField *passwordTextField;

/**
 * Delegate
 */
@property (nonatomic,weak) id<DWTwitterConnectViewControllerDelegate,NSObject> delegate;

@end


/**
 * Protocol for delegates of DWTwitterConnectViewController
 */
@protocol DWTwitterConnectViewControllerDelegate

@optional

/**
 * Twitter authorized
 */
- (void)twitterAuthorized;

/**
 * Twitter authorization failed
 */
- (void)twitterAuthorizationFailed;

@end