//
//  DWNotificationsController.h
//  Mine
//
//  Created by Siddharth Batra on 10/14/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DWNotificationsControllerDelegate;


@interface DWNotificationsController : NSObject {
    __weak id<DWNotificationsControllerDelegate,NSObject> _delegate;
}

@property (nonatomic,weak) id<DWNotificationsControllerDelegate,NSObject> delegate;


- (void)getNotifications;

@end


@protocol DWNotificationsControllerDelegate

@required

- (void)notificationsLoaded:(NSMutableArray*)notifications;
- (void)notificationsLoadError:(NSString*)error;

@end