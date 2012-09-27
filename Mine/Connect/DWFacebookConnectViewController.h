//
//  DWFacebookConnectViewController.h
//  Mine
//
//  Created by Deepak Rao on 8/7/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DWFacebookConnect.h"
#import "DWUsersController.h"

@protocol DWFacebookConnectViewControllerDelegate;

@interface DWFacebookConnectViewController : UIViewController<DWFacebookConnectDelegate,DWUsersControllerDelegate> {
    __weak id<DWFacebookConnectViewControllerDelegate,NSObject> _delegate;    
}

/**
 * Delegate
 */
@property (nonatomic,weak) id<DWFacebookConnectViewControllerDelegate,NSObject> delegate;

@end


/**
 * Protocol for the delegates of DWFacebookConnectViewController
 */
@protocol DWFacebookConnectViewControllerDelegate

@optional

- (void)facebookConfigured;

@end