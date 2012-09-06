//
//  DWFollowingsController.h
//  Mine
//
//  Created by Siddharth Batra on 8/4/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DWFollowing;
@protocol DWFollowingsControllerDelegate;

@interface DWFollowingsController : NSObject {
    __weak id<DWFollowingsControllerDelegate,NSObject> _delegate;
}

/**
 * Delegate following the DWFollowingsControllerDelegate.
 */
@property (nonatomic,weak) id<DWFollowingsControllerDelegate,NSObject> delegate;


/**
 * Fetch the status of a following between the current user and the given user.
 */
- (void)getFollowingForUserID:(NSInteger)userID;

/**
 * Fetch all followings for the current user.
 */
- (void)getFollowings;

/**
 * Create a new following between the current user and the given user.
 */
- (void)createFollowingForUserID:(NSInteger)userID;

/**
 * Destroy following between the current user and the given user.
 */
- (void)destroyFollowing:(NSInteger)followingID
               ForUserID:(NSInteger)userID;

@end


/**
 * Delegate for DWFollowingsController informing about the
 * status of successful and failed requests.
 */
@protocol DWFollowingsControllerDelegate

@optional

/**
 * Status of following loaded.
 */
- (void)followingLoaded:(DWFollowing*)following 
              forUserID:(NSNumber*)userID;

/**
 * Error loading status of a following.
 */
- (void)followingLoadError:(NSString*)message
                 forUserID:(NSNumber*)userID;

/**
 * All followings of the current user loaded.
 */
- (void)followingsLoaded:(NSMutableArray*)followings;

/**
 * Error loading followings for the currrent user.
 */
- (void)followingsLoadError:(NSString*)message;

/**
 * Following created.
 */
- (void)followingCreated:(DWFollowing*)following 
               forUserID:(NSNumber*)userID;

/**
 * Error creating following.
 */
- (void)followingCreateError:(NSString*)message
                   forUserID:(NSNumber*)userID;


/**
 * Following destroyed.
 */
- (void)followingDestroyed:(DWFollowing*)following 
                 forUserID:(NSNumber*)userID;

/**
 * Error destroying following.
 */
- (void)followingDestroyError:(NSString*)message
                    forUserID:(NSNumber*)userID;


@end