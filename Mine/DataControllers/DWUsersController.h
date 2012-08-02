//
//  DWUsersController.h
//  Mine
//
//  Created by Siddharth Batra on 7/20/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWUser.h"


@protocol DWUsersControllerDelegate;


@interface DWUsersController : NSObject {
    __weak id<DWUsersControllerDelegate,NSObject> _delegate;
}


/**
 * Delegate for the DWUsersControllerDelegate protocol
 */
@property (nonatomic,weak) id<DWUsersControllerDelegate,NSObject> delegate;



/**
 * Create user from facebook authentication
 */
- (void)createUserFromFacebookWithAccessToken:(NSString*)accessToken;

/**
 * Fetch information about the user with the given id.
 */
- (void)getUserWithID:(NSInteger)userID;

/**
 * Fetch users who've liked the given purchase id.
 */ 
- (void)getLikersForPurchaseID:(NSInteger)purchaseID;

/**
 * Fetch followers of the given user
 */ 
- (void)getFollowersForUserID:(NSInteger)userID;

/**
 * Fetch ifollowers of the given user
 */ 
- (void)getIFollowersForUserID:(NSInteger)userID;


/**
 * Update the tumblr token and secret of the given user ID
 */
- (void)updateUserHavingID:(NSInteger)userID 
          withTumblrToken:(NSString*)tumblrToken
          andTumblrSecret:(NSString*)tumblrSecret;

/**
 * Update the twitter token and secret of the given user ID
 */
- (void)updateUserHavingID:(NSInteger)userID 
           withTwitterToken:(NSString*)twitterToken
           andTwitterSecret:(NSString*)twitterSecret;

@end



/**
 * Protocol for the UserController delegate. Fires 
 * messages about the success and failure of requests
 */
@protocol DWUsersControllerDelegate

@optional

/**
 * Used for pinging the delegate for a resource id
 */
- (NSInteger)userResourceID;

/**
 * Fired when a user is created
 */
- (void)userCreated:(DWUser*)user;

/**
 * Error message while creating a user
 */
- (void)userCreationError:(NSString*)error;

/**
 * User information loaded from the app server
 */
- (void)userLoaded:(DWUser*)user;

/**
 * Error loading user information
 */
- (void)userLoadError:(NSString*)error;

/**
 * Fired when a user is updated
 */
- (void)userUpdated:(DWUser*)user;

/**
 * Error message while updating a user
 */
- (void)userUpdateError:(NSString*)error;


/**
 * Likers of a purchase loaded.
 */
- (void)likersLoaded:(NSMutableArray*)users 
       forPurchaseID:(NSNumber*)purchaseID;

/**
 * Error loading likers of a purchase.
 */
- (void)likersLoadError:(NSString*)error 
          forPurchaseID:(NSNumber*)purchaseID;


/**
 * Followers of a user loaded.
 */
- (void)followersLoaded:(NSMutableArray*)users 
              forUserID:(NSNumber*)userID;

/**
 * Error loading followers of a user.
 */
- (void)followersLoadError:(NSString*)error 
                 forUserID:(NSNumber*)userID;


/**
 * IFollowers of a user loaded.
 */
- (void)ifollowersLoaded:(NSMutableArray*)users 
               forUserID:(NSNumber*)userID;

/**
 * Error loading ifollowers of a user.
 */
- (void)ifollowersLoadError:(NSString*)error 
                  forUserID:(NSNumber*)userID;

@end
