//
//  DWLoginViewController.h
//  Mine
//
//  Created by Siddharth Batra on 7/25/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DWUsersController.h"
#import "DWFacebookConnect.h"
#import "DWTwitterConnectViewController.h"


@protocol DWLoginViewControllerDelegate;

/**
 * Displays view for logging in existing users.
 */
@interface DWLoginViewController : UIViewController<DWUsersControllerDelegate,DWFacebookConnectDelegate,DWTwitterConnectViewControllerDelegate> {
    
    UIButton *_loginWithFBButton;
    UIButton *_loginWithTWButton;
    
    __weak id<DWLoginViewControllerDelegate> _delegate;
}

/**
 * Delegate following the DWLoginViewControllerDelegate protocol.
 */
@property (nonatomic,weak) id<DWLoginViewControllerDelegate> delegate;

/**
 * IBOutlets
 */
@property (nonatomic) IBOutlet UIButton *loginWithFBButton;
@property (nonatomic) IBOutlet UIButton *loginWithTWButton;


/**
 * IBActions
 */
 - (IBAction)loginWithFBButtonClicked:(id)sender;
 - (IBAction)loginWithTWButtonClicked:(id)sender;

@end


/**
 * Protocol for DWLoginViewController delegates.
 */
@protocol DWLoginViewControllerDelegate

@required

/**
 * Return a navigation controller for use inside the login view.
 */
- (UINavigationController*)loginViewNavigationController;

/**
 * User successfully logs in.
 */
- (void)userLoggedIn:(DWUser*)user;

@end
