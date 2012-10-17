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
    
    self.view.backgroundColor = [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1.0];
    
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
    
    if([notification.resourceType isEqualToString:@"User"]) {
        [self.delegate notificationsViewDisplayUser:notification.user];
    }
    else if([notification.resourceType isEqualToString:@"Purchase"]) {
        [self.delegate notificationsViewDisplayPurchase:notification.purchase];
        
    }
}



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors

//----------------------------------------------------------------------------------------------------
- (void)requiresFullScreenMode {
    
}

@end
