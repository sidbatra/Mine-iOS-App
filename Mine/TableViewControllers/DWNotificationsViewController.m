//
//  DWNotificationsViewController.m
//  Mine
//
//  Created by Siddharth Batra on 10/14/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWNotificationsViewController.h"
#import "DWNotificationsDataSource.h"
#import "DWNotificationPresenter.h"
#import "DWNotification.h"
#import "DWGUIManager.h"
#import "DWAnalyticsManager.h"
#import "DWConstants.h"


@interface DWNotificationsViewController ()

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWNotificationsViewController

@synthesize delegate = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        
        self.tableViewDataSource = [[DWNotificationsDataSource alloc] init];
        
        [self addModelPresenterForClass:[DWNotification class]
                              withStyle:kDefaultModelPresenter
                          withPresenter:[DWNotificationPresenter class]];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notificationImageLoaded:)
                                                     name:kNImgNotificationLoaded
                                                   object:nil];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [DWGUIManager navBarCloseButtonWithTarget:self];
    self.navigationItem.titleView = [DWGUIManager navBarTitleViewWithText:@"Notifications"];
    
    [(DWNotificationsDataSource*)self.tableViewDataSource loadNotifications];
    
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Notifications View"];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UI Events

//----------------------------------------------------------------------------------------------------
- (void)closeButtonClicked {
    [self.navigationController popViewControllerAnimated:NO];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)notificationImageLoaded:(NSNotification*)notification {
    NSDictionary *userInfo = [notification userInfo];
    
    [self provideResourceToVisibleCells:[DWNotification class]
                               objectID:[[userInfo objectForKey:kKeyResourceID] integerValue]
                              objectKey:kKeyImageURL];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notification presenter events

//----------------------------------------------------------------------------------------------------
- (void)notificationClicked:(DWNotification*)notification {
    notification.unread = NO;
    
    [self provideResourceToVisibleCells:[DWNotification class]
                               objectID:notification.databaseID
                              objectKey:kKeyUnread];
    
    switch(notification.identifier) {
        case DWNotificationIdentifierLike:
            [self.delegate notificationsViewDisplayLikersFor:notification.purchase];
        break;
        case DWNotificationIdentifierComment:
            [self.delegate notificationsViewDisplayCommentorsFor:notification.purchase];
        break;
        case DWNotificationIdentifierFollowing:
            [self.delegate notificationsViewDisplayUser:notification.user];
        break;
    }
}

@end