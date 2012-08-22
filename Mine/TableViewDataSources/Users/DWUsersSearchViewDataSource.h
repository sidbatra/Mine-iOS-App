//
//  DWUsersSearchViewDataSource.h
//  Mine
//
//  Created by Siddharth Batra on 8/22/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWUsersViewDataSource.h"

@interface DWUsersSearchViewDataSource : DWUsersViewDataSource

/**
 * Load users via data controller for given query.
 */
- (void)loadUsersForQuery:(NSString*)query;

@end
