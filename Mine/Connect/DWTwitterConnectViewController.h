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
    
    BOOL                _updateCurrentUser;
    
    __weak id<DWTwitterConnectViewControllerDelegate,NSObject> _delegate;    
}

/**
 * IBOutlet properties
 */
@property (nonatomic) IBOutlet UITextField *usernameTextField;
@property (nonatomic) IBOutlet UITextField *passwordTextField;


/**
 * Update the current user locally & remotely with the freshly obtained token & secret.
 */
@property (nonatomic,assign) BOOL updateCurrentUser;

/**
 * Delegate
 */
@property (nonatomic,weak) id<DWTwitterConnectViewControllerDelegate,NSObject> delegate;

@end


/**
 * Protocol for the delegates of DWTwitterConnectViewController
 */
@protocol DWTwitterConnectViewControllerDelegate 

@optional

- (void)twitterConfigured;

- (void)twitterAuthorizedWithAccessToken:(NSString*)accessToken 
                    andAccessTokenSecret:(NSString*)accessTokenSecret;

@end
