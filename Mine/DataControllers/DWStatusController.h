//
//  DWStatusController.h
//  Mine
//
//  Created by Siddharth Batra on 8/7/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DWUser;
@protocol DWStatusControllerDelegate;


@interface DWStatusController : NSObject {
    __weak id<DWStatusControllerDelegate,NSObject> _delegate;
}

/**
 * Delegates based on the the DWStatusControllerDelegate protocol.
 */
@property (nonatomic,weak) id<DWStatusControllerDelegate,NSObject> delegate;

@end


/**
 * Protocol for delegates of DWStatusController to get request status updates.
 */
@protocol DWStatusControllerDelegate

@optional

/**
 * Status has been successfully loaded.
 */
- (void)statusLoaded:(DWUser*)user;

/**
 * Error loading status.
 */
- (void)statusLoadError:(NSString*)error;

@end
