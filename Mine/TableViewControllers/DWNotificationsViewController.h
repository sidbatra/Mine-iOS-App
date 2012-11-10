//
//  DWNotificationsViewController.h
//  Mine
//
//  Created by Siddharth Batra on 10/14/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWTableViewController.h"

@class DWPurchase;
@class DWUser;
@protocol DWNotificationsViewControllerDelegate;


@interface DWNotificationsViewController : DWTableViewController {
    __weak id<DWNotificationsViewControllerDelegate,NSObject> _delegate;
}

@property (nonatomic,weak) id<DWNotificationsViewControllerDelegate,NSObject> delegate;

@end


@protocol DWNotificationsViewControllerDelegate

@required

- (void)notificationsViewDisplayPurchase:(DWPurchase*)purchase;
- (void)notificationsViewDisplayUser:(DWUser*)user;
- (void)notificationsViewDisplayUnapprovedPurchases;

@end