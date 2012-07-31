//
//  DWProductsController.h
//  Mine
//
//  Created by Deepak Rao on 7/30/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DWProductsControllerDelegate;

@interface DWProductsController : NSObject {
    __weak id<DWProductsControllerDelegate,NSObject> _delegate;
}

/**
 * Delegate for the DWProductsControllerDelegate protocol
 */
@property (nonatomic,weak) id<DWProductsControllerDelegate,NSObject> delegate;

/**
 * Fetch products for the given query and page
 */
- (void)getProductsForQuery:(NSString*)query 
                    andPage:(NSInteger)page;
@end


/**
 * Protocol for the DWProductsController delegate. Fires 
 * messages about the success and failure of requests
 */
@protocol DWProductsControllerDelegate

@optional

/**
 * Products for a query are loaded successfully.
 */
- (void)productsLoaded:(NSMutableArray*)products
           withQueries:(NSArray*)queries;

/**
 * Error loading products.
 */
- (void)productsLoadError:(NSString*)error;

@end