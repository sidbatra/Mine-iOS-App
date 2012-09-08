//
//  DWFollowingManager.h
//  Mine
//
//  Created by Siddharth Batra on 9/8/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWFollowingsController.h"


@interface DWFollowingManager : NSObject<DWFollowingsControllerDelegate> {
    BOOL _areBulkFollowingsLoaded;
}

/**
 * Whether all the followings of the current user have been fetched remotely.
 */
@property (nonatomic,assign) BOOL areBulkFollowingsLoaded;

/**
 * The sole shared instance of the class
 */
+ (DWFollowingManager*)sharedDWFollowingManager;



/**
 * Return first following in memory pool for the given user id.
 */
- (DWFollowing*)followingForUserID:(NSInteger)userID;

@end
