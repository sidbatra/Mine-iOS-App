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
 * User information loaded from the app server
 */
- (void)userLoaded:(DWUser*)user;

/**
 * Error loading user information
 */
- (void)userLoadError:(DWUser*)user;

@end