//
//  DWFeedController.h
//  Mine
//
//  Created by Siddharth Batra on 7/21/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol DWFeedControllerDelegate;


@interface DWFeedController : NSObject {
    __weak id<DWFeedControllerDelegate,NSObject> _delegate;
}


/**
 * Delegate for the DWFeedControllerDelegate protocol
 */
@property (nonatomic,weak) id<DWFeedControllerDelegate,NSObject> delegate;


/**
 * Fetch purchases before the given time
 */
- (void)getPurchasesBefore:(NSTimeInterval)before;

@end


/**
 * Protocol for the DWFeedController delegate. Fires 
 * messages about the success and failure of requests
 */
@protocol DWFeedControllerDelegate

@required

/**
 * Feed items are loaded successfully.
 */
- (void)feedLoaded:(NSMutableArray*)purchases;

/**
 * Error loading feed items.
 */
- (void)feedLoadError:(NSString*)error;


@end