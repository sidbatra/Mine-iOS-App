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
    UITextField             *_emailTextField;
    UISegmentedControl      *_genderSegmentedControl;
    
    __weak id<NSObject,DWUserDetailsViewControllerDelegate> _delegate;
}

/**
 * IBOutlets
 */
@property (nonatomic) IBOutlet UITextField *emailTextField;
@property (nonatomic) IBOutlet UISegmentedControl *genderSegmentedControl;


@property (nonatomic,weak) id<NSObject,DWUserDetailsViewControllerDelegate> delegate;

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