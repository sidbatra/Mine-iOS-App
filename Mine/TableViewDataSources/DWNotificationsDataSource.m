//
//  DWNotificationsDataSource.m
//  Mine
//
//  Created by Siddharth Batra on 10/14/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWNotificationsDataSource.h"

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
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWNotificationsControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)notificationsLoaded:(NSMutableArray *)notifications {
    self.objects = notifications;
    [self.delegate reloadTableView];
}

//----------------------------------------------------------------------------------------------------
- (void)notificationsLoadError:(NSString *)error {
    [self.delegate displayError:error
                  withRefreshUI:YES];
}

@end
