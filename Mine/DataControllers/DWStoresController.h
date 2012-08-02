//
//  DWStoresController.h
//  Mine
//
//  Created by Siddharth Batra on 8/1/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol DWStoresControllerDelegate;


@interface DWStoresController : NSObject {
    __weak id<DWStoresControllerDelegate,NSObject> _delegate;
}

/**
 * Delegate following the DWStoresControllerDelegate protocol.
 */
@property (nonatomic,weak) id<DWStoresControllerDelegate,NSObject> delegate;


/**
 * Fetch all stores.
 */
- (void)getAllStores;


@end




@protocol DWStoresControllerDelegate

@optional

/**
 * Stores loaded successfully.
 */
- (void)storesLoaded:(NSMutableArray*)stores;

/**
 * Error loading stores.
 */
- (void)storesLoadError:(NSString*)error;


@end
