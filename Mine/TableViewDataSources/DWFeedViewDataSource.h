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


@interface DWFeedViewDataSource : DWTableViewDataSource<DWFeedControllerDelegate,DWPurchasesControllerDelegate>

/**
 * Load the feed items and start the infinite pagination loop.
 */
- (void)loadFeed;

@end
