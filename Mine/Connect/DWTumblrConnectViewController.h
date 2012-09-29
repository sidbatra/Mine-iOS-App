//
//  DWTumblrConnectViewController.h
//  Mine
//
//  Created by Deepak Rao on 8/7/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DWTumblrConnect.h"
#import "DWUsersController.h"

@protocol DWTumblrConnectViewControllerDelegate;

@interface DWTumblrConnectViewController : UIViewController<UITextFieldDelegate,DWTumblrConnectDelegate,DWUsersControllerDelegate> {
    UITextField         *_emailTextField;
    UITextField         *_passwordTextField;
    UIView              *_loadingView;       
    
    __weak id<DWTumblrConnectViewControllerDelegate,NSObject> _delegate;  
}

/**
 * IBOutlet properties
 */
@property (nonatomic) IBOutlet UITextField *emailTextField;
@property (nonatomic) IBOutlet UITextField *passwordTextField;
@property (nonatomic) IBOutlet UIView *loadingView;

/**
 * Delegate
 */
@property (nonatomic,weak) id<DWTumblrConnectViewControllerDelegate,NSObject> delegate;

@end


/**
 * Protocol for the delegates of DWTumblrConnectViewController
 */
@protocol DWTumblrConnectViewControllerDelegate 

@optional

- (void)tumblrConfigured;

@end