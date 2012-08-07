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


@interface DWTwitterConnectViewController : UIViewController<UITextFieldDelegate,DWTwitterConnectDelegate,DWUsersControllerDelegate> {
    UITextField         *_usernameTextField;
    UITextField         *_passwordTextField;
}

/**
 * IBOutlet properties
 */
@property (nonatomic) IBOutlet UITextField *usernameTextField;
@property (nonatomic) IBOutlet UITextField *passwordTextField;

@end