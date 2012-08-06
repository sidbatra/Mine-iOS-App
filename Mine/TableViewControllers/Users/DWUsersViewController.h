//
//  DWUsersViewController.h
//  Mine
//
//  Created by Siddharth Batra on 8/2/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWTableViewController.h"

@class DWUser;
@protocol DWUsersViewControllerDelegate;

@interface DWUsersViewController : DWTableViewController {
    __weak id<DWUsersViewControllerDelegate,NSObject> _delegate;
}

/**
 * Delegate following the DWUsersViewControllerDelegate protocol.
 */
@property (nonatomic,weak) id<DWUsersViewControllerDelegate,NSObject> delegate;

@end



/**
 * Protocol for delegates of DWUsersViewController
 */
@protocol DWUsersViewControllerDelegate

@required

/**
 * A user element is clicked. 
 */
- (void)usersViewUserClicked:(DWUser*)user;

@end