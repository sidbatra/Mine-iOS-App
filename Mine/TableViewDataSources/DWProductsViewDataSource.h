//
//  DWProductsViewDataSource.h
//  Mine
//
//  Created by Deepak Rao on 7/30/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWTableViewDataSource.h"
#import "DWProductsController.h"


@interface DWProductsViewDataSource : DWTableViewDataSource<DWProductsControllerDelegate>

/**
 * Load products for the given query
 */
- (void)loadProductsForQuery:(NSString*)query;

@end
