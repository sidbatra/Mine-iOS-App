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
    
     [(DWNotificationsDataSource*)self.tableViewDataSource loadNotifications];
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
    [self.delegate notificationsViewNotificationClicked:notification];
}

@end
