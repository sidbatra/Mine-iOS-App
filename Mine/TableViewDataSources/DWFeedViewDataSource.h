//
//  DWFeedViewDataSource.h
//  Mine
//
//  Created by Siddharth Batra on 7/23/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWTableViewDataSource.h"
#import "DWFeedController.h"
#import "DWPurchasesController.h"

@protocol DWFeedViewDataSourceDelegate;

@interface DWFeedViewDataSource : DWTableViewDataSource<DWFeedControllerDelegate,DWPurchasesControllerDelegate>


/**
 * Redefined delegate object
 */
@property (nonatomic,weak) id<DWFeedViewDataSourceDelegate,DWTableViewDataSourceDelegate,NSObject> delegate;


/**
 * Load the feed items and start the infinite pagination loop.
 */
- (void)loadFeed;

/**
 * Delete a purchase with the given ID
 */
- (void)deletePurchase:(NSInteger)purchaseID;

@end


/**
 * Additional delegate methods for the data source
 */
@protocol DWFeedViewDataSourceDelegate

@end