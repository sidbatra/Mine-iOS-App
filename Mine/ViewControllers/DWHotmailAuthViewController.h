//
//  DWHotmailAuthViewController.h
//  Mine
//
//  Created by Siddharth Batra on 12/21/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWHotmailController.h"


@protocol DWHotmailAuthViewControllerDelegate;

@interface DWHotmailAuthViewController : UIViewController<UITextFieldDelegate,DWHotmailControllerDelegate> {
    DWHotmailController *_hotmailController;

    UITextField         *_emailTextField;
    UITextField         *_passwordTextField;
    UIView              *_loadingView;

    __weak id<DWHotmailAuthViewControllerDelegate,NSObject> _delegate;
}

@property (nonatomic,strong) DWHotmailController *hotmailController;

/**
 * IBOutlet properties
 */
@property (nonatomic) IBOutlet UITextField *emailTextField;
@property (nonatomic) IBOutlet UITextField *passwordTextField;
@property (nonatomic) IBOutlet UIView *loadingView;

/**
 * Delegate
 */
@property (nonatomic,weak) id<DWHotmailAuthViewControllerDelegate,NSObject> delegate;

@end


@protocol DWHotmailAuthViewControllerDelegate

@optional

- (void)hotmailAuthAccepted;
- (void)hotmailAuthRejected;

@end