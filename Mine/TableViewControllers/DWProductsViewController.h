//
//  DWProductsViewController.h
//  Mine
//
//  Created by Deepak Rao on 7/30/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWTableViewController.h"
#import "DWProductsViewDataSource.h"

@protocol DWProductsViewControllerDelegate;


@interface DWProductsViewController : DWTableViewController<DWProductsViewDataSourceDelegate> {
    __weak id<DWProductsViewControllerDelegate,NSObject> _delegate;
}

/**
 * Delegate
 */
@property (nonatomic,weak) id<DWProductsViewControllerDelegate,NSObject> delegate;


/**
 * Search products for the given query
 */
- (void)searchProductsForQuery:(NSString*)query;

@end


/**
 * Protocol for delegates of DWProductsViewController
 */
@protocol DWProductsViewControllerDelegate

/**
 * Fired the products are loaded
 */
- (void)productsLoaded;

@end