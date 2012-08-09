//
//  DWStoresViewController.h
//  Mine
//
//  Created by Deepak Rao on 8/9/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWTableViewController.h"

#import "DWStoresViewDataSource.h"

@class DWStore;
@protocol DWStoresViewControllerDelegate;


@interface DWStoresViewController : DWTableViewController<DWStoresViewDataSourceDelegate> {
    __weak id<DWStoresViewControllerDelegate,NSObject> _delegate;
}

/**
 * Delegate
 */
@property (nonatomic,weak) id<DWStoresViewControllerDelegate,NSObject> delegate;


/**
 * Load all stores from the database
 */
- (void)loadAllStores;

/**
 * Search stores for the given query
 */
- (void)searchStoresForQuery:(NSString*)query;

@end


/**
 * Protocol for delegates of DWStoresViewController
 */
@protocol DWStoresViewControllerDelegate

@required

/**
 * Fired when a store element is selected
 */
- (void)storeSelected:(DWStore*)store;

@end