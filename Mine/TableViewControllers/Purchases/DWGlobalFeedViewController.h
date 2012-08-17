//
//  DWGlobalFeedViewController.h
//  Mine
//
//  Created by Deepak Rao on 8/16/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWPurchasesViewController.h"


@protocol DWGlobalFeedViewControllerDelegate;


@interface DWGlobalFeedViewController : DWPurchasesViewController {
}

/**
 * Redefine the delegate
 */
@property (nonatomic,weak) id<DWPurchasesViewControllerDelegate,DWGlobalFeedViewControllerDelegate,NSObject> delegate;

@end


/**
 * Protocol for delegates of DWGlobalFeedViewController
 */
@protocol DWGlobalFeedViewControllerDelegate

@optional

/**
 * Fired to show the screen after global feed.
 */
- (void)showScreenAfterGlobalFeed;

@end