//
//  DWFeedViewDataSource.h
//  Mine
//
//  Created by Siddharth Batra on 7/23/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWTableViewDataSource.h"
#import "DWUsersController.h"
#import "DWFeedController.h"
#import "DWPurchasesController.h"
#import "DWFollowingsController.h"

@protocol DWFeedViewDataSourceDelegate;

@interface DWFeedViewDataSource : DWTableViewDataSource<DWFeedControllerDelegate,DWPurchasesControllerDelegate,DWUsersControllerDelegate,DWFollowingsControllerDelegate>


/**
 * Redefined delegate object
 */
@property (nonatomic,weak) id<DWFeedViewDataSourceDelegate,DWTableViewDataSourceDelegate,NSObject> delegate;


/**
 * Load user suggestions for who to follow
 */
- (void)loadUserSuggestions;

/**
 * Load the feed items and start the infinite pagination loop.
 */
- (void)loadFeed;

/**
 * Delete a purchase with the given ID
 */
- (void)deletePurchase:(NSInteger)purchaseID;

/**
 * Toggle remote & local status of following between current user and user id.
 */
- (void)toggleFollowForUserID:(NSInteger)userID;

@end


/**
 * Additional delegate methods for the data source
 */
@protocol DWFeedViewDataSourceDelegate

@required

- (void)followingModifiedForUserID:(NSInteger)userID toStatus:(BOOL)isActive;

@end