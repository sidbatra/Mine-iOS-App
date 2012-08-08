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
#import "DWUser.h"


@interface DWSession : NSObject<DWStatusControllerDelegate,DWUsersControllerDelegate> {
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

@end
