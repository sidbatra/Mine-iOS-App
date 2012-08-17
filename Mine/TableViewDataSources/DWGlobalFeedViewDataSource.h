//
//  DWGlobalFeedViewDataSource.h
//  Mine
//
//  Created by Deepak Rao on 8/16/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWTableViewDataSource.h"
#import "DWFeedController.h"

@interface DWGlobalFeedViewDataSource : DWTableViewDataSource<DWFeedControllerDelegate>

/**
 * Load the feed items and start the infinite pagination loop.
 */
- (void)loadFeed;

@end