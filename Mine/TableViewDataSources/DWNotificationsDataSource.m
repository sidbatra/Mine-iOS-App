//
//  DWNotificationsDataSource.m
//  Mine
//
//  Created by Siddharth Batra on 10/14/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWNotificationsDataSource.h"
#import "DWNotification.h"
#import "DWSession.h"


@interface DWNotificationsDataSource() {
    DWNotificationsController   *_notificationsController;
}

@property (nonatomic,strong) DWNotificationsController *notificationsController;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWNotificationsDataSource

@synthesize notificationsController = _notificationsController;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.notificationsController = [[DWNotificationsController alloc] init];
        self.notificationsController.delegate = self;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)loadNotifications {
    [self.notificationsController getNotifications];
}

//----------------------------------------------------------------------------------------------------
- (void)refreshInitiated {
    [self loadNotifications];
}

//----------------------------------------------------------------------------------------------------
- (NSMutableArray*)unreadNotificationIDs {
    NSMutableArray *notificationIDs = [NSMutableArray array];
    
    for(DWNotification *notification in self.objects) {
        if(notification.unread)
            [notificationIDs addObject:[NSNumber numberWithInteger:notification.databaseID]];
    }
    
    return notificationIDs;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWNotificationsControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)notificationsLoaded:(NSMutableArray *)notifications {
    self.objects = notifications;
    [self.delegate reloadTableView];
    
    NSMutableArray *notificationIDs = [self unreadNotificationIDs];
    
    if(notificationIDs.count) {
        [self.notificationsController markNotificationsAsRead:notificationIDs];
    }
    
   [[DWSession sharedDWSession] resetUnreadNotificationsCount];
}

//----------------------------------------------------------------------------------------------------
- (void)notificationsLoadError:(NSString *)error {
    [self.delegate displayError:error
                  withRefreshUI:YES];
}

@end
