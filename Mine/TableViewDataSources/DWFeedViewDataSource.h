//
//  DWFeedViewDataSource.h
//  Mine
//
//  Created by Siddharth Batra on 7/23/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWTableViewDataSource.h"
#import "DWFeedController.h"


@interface DWFeedViewDataSource : DWTableViewDataSource<DWFeedControllerDelegate>

/**
 * Load the feed items and start the infinite pagination loop.
 */
- (void)loadFeed;

@end
