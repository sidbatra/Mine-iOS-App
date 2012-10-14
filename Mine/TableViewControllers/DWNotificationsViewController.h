//
//  DWNotificationsViewController.h
//  Mine
//
//  Created by Siddharth Batra on 10/14/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWTableViewController.h"

@class DWNotification;
@protocol DWNotificationsViewControllerDelegate;


@interface DWNotificationsViewController : DWTableViewController {
    __weak id<DWNotificationsViewControllerDelegate,NSObject> _delegate;
}

@property (nonatomic,weak) id<DWNotificationsViewControllerDelegate,NSObject> delegate;

@end


@protocol DWNotificationsViewControllerDelegate

@required

- (void)notificationsViewNotificationClicked:(DWNotification*)notification;

@end