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
    
    UIButton *_playButton;
    UIButton *_loginWithFBButton;
    UIButton *_loginWithTWButton;
    
    UIImageView *_loadingFBImageView;
    UIImageView *_loadingTWImageView;
    
    UIActivityIndicatorView *_loadingFBSpinner;
    UIActivityIndicatorView *_loadingTWSpinner;
    
    __weak id<DWLoginViewControllerDelegate> _delegate;
}

/**
 * Delegate following the DWLoginViewControllerDelegate protocol.
 */
@property (nonatomic,weak) id<DWLoginViewControllerDelegate> delegate;

/**
 * IBOutlets
 */
@property (nonatomic) IBOutlet UIButton *playButton;
@property (nonatomic) IBOutlet UIButton *loginWithFBButton;
@property (nonatomic) IBOutlet UIButton *loginWithTWButton;
@property (nonatomic) IBOutlet UIImageView *loadingFBImageView;
@property (nonatomic) IBOutlet UIImageView *loadingTWImageView;
@property (nonatomic) IBOutlet UIActivityIndicatorView *loadingFBSpinner;
@property (nonatomic) IBOutlet UIActivityIndicatorView *loadingTWSpinner;

/**
 * IBActions
 */
- (IBAction)playButtonClicked:(id)sender;
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
