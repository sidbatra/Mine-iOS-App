//
//  DWUserDetailsViewController.h
//  Mine
//
//  Created by Siddharth Batra on 8/27/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DWUsersController.h"

@protocol DWUserDetailsViewControllerDelegate;


@interface DWUserDetailsViewController : UIViewController<DWUsersControllerDelegate> {
    UILabel                 *_titleLabel;
    UILabel                 *_exampleLabel;
    UITextField             *_emailTextField;
    UIButton                *_maleButton;
    UIButton                *_femaleButton;
    
    __weak id<NSObject,DWUserDetailsViewControllerDelegate> _delegate;
}

/**
 * IBOutlets
 */
@property (nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic) IBOutlet UILabel *exampleLabel;
@property (nonatomic) IBOutlet UITextField *emailTextField;
@property (nonatomic) IBOutlet UIButton *maleButton;
@property (nonatomic) IBOutlet UIButton *femaleButton;


@property (nonatomic,weak) id<NSObject,DWUserDetailsViewControllerDelegate> delegate;


/**
 * IBActions
 */
- (IBAction)maleButtonClicked:(id)sender;
- (IBAction)femaleButtonClicked:(id)sender;

@end


/**
 * Protocol for delegates of DWUserDetailsViewController.
 */
@protocol DWUserDetailsViewControllerDelegate

@required

/**
 * Fired when the entered user details have been synced remotely.
 */
- (void)userDetailsUpdated;

@end