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
 * Fetch information about the user with the given id.
 */
- (void)getUserWithID:(NSInteger)userID;

/**
 * Create user from facebook authentication
 */
- (void)createUserFromFacebookWithAccessToken:(NSString*)accessToken;

/**
 * Update the tumblr token and secret of the given user ID
 */
- (void)updateUserHavingID:(NSInteger)userID 
          withTumblrToken:(NSString*)tumblrToken
          andTumblrSecret:(NSString*)tumblrSecret;

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

@end