//
//  DWFeedNavigationViewController.h
//  Mine
//
//  Created by Siddharth Batra on 7/25/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWNavigationRootViewController.h"

#import "DWFeedViewController.h"
#import "DWNotificationsViewController.h"
#import "DWQueueProgressView.h"
#import "DWNavigationBarCountView.h"
#import "DWCreationNavigationViewController.h"



@interface DWFeedNavigationViewController : DWNavigationRootViewController<DWFeedViewControllerDelegate,DWQueueProgressViewDelegate,DWNavigationBarCountViewDelegate,
                                                DWNotificationsViewControllerDelegate,DWCreationNavigationViewControllerDelegate>

@end
