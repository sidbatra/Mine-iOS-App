//
//  DWUsersSearchViewController.h
//  Mine
//
//  Created by Siddharth Batra on 8/22/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWUsersViewController.h"

@interface DWUsersSearchViewController : DWUsersViewController

/**
 * Clear the UI and start a new search.
 */
- (void)loadUsersForQuery:(NSString*)query;

@end
