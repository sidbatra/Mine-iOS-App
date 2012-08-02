//
//  DWStoresController.h
//  Mine
//
//  Created by Siddharth Batra on 8/1/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


enum {
    DWStoresAspectAll = 1
}DWStoresAspect;


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
 * Stores loaded successfully along with the aspect
 * of stores loaded - See DWStoresAspect.
 */
- (void)storesLoaded:(NSMutableArray*)stores 
          withAspect:(NSNumber*)aspect;

/**
 * Error loading stores along with the aspect that failed.
 * See DWStoresAspect.
 */
- (void)storesLoadError:(NSString*)error
             withAspect:(NSNumber*)aspect;


@end
