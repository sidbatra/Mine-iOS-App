//
//  DWSession.h
//  Mine
//
//  Created by Siddharth Batra on 7/20/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWStatusController.h"
#import "DWUsersController.h"
#import "DWPurchasesController.h"
#import "DWUser.h"


@interface DWSession : NSObject<DWStatusControllerDelegate,DWUsersControllerDelegate,DWPurchasesControllerDelegate> {
    DWUser  *_currentUser;
}

/**
 * Shared instance of the Singleton class
 */
+ (DWSession *)sharedDWSession;

/**
 * DWUser instance representing the current user
 */
@property (nonatomic,strong) DWUser* currentUser;


/**
 * Create an authenticated session in memory and on disk.
 */
- (void)create:(DWUser*)user;

/**
 * Update the authenticated session in memory and on disk.
 */
- (void)update;

/**
 * Destroy in-memory and disk session.
 */
- (void)destroy;

/**
 * Test whether the session is authenticated.
 */
- (BOOL)isAuthenticated;

/**
 * Test if the given user id is the current user's id.
 */
- (BOOL)isCurrentUser:(NSInteger)userID;

/**
 * Updates the session once the email has been authorized
 */
- (void)emailAuthorized;

/**
 * Reset the current users unread notification count to user and
 * fire notifications to update UI.
 */
- (void)resetUnreadNotificationsCount;

@end
