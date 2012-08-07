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


@interface DWTumblrConnectViewController : UIViewController<UITextFieldDelegate,DWTumblrConnectDelegate,DWUsersControllerDelegate> {
    UITextField         *_emailTextField;
    UITextField         *_passwordTextField;
}

/**
 * IBOutlet properties
 */
@property (nonatomic) IBOutlet UITextField *emailTextField;
@property (nonatomic) IBOutlet UITextField *passwordTextField;

@end