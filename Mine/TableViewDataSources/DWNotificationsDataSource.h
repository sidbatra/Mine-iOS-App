//
//  DWNotificationsDataSource.h
//  Mine
//
//  Created by Siddharth Batra on 10/14/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWTableViewDataSource.h"

#import "DWNotificationsController.h"


@interface DWNotificationsDataSource : DWTableViewDataSource<DWNotificationsControllerDelegate>


- (void)loadNotifications;

@end
