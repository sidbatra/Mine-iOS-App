//
//  DWProductsViewDataSource.h
//  Mine
//
//  Created by Deepak Rao on 7/30/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWTableViewDataSource.h"
#import "DWProductsController.h"

@protocol DWProductsViewDataSourceDelegate;


@interface DWProductsViewDataSource : DWTableViewDataSource<DWProductsControllerDelegate> {
    
}

/**
 * Redefined delegate object
 */
@property (nonatomic,weak) id<DWProductsViewDataSourceDelegate,DWTableViewDataSourceDelegate,NSObject> delegate;


/**
 * Load products for the given query
 */
- (void)loadProductsForQuery:(NSString*)query;

@end


/**
 * Additional delegate methods for the data source
 */
@protocol DWProductsViewDataSourceDelegate<DWTableViewDataSourceDelegate>

/**
 * Fired when the products are loaded
 */
- (void)productsLoaded;

@end

