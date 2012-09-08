//
//  DWUsersViewDataSource.h
//  Mine
//
//  Created by Siddharth Batra on 8/2/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWTableViewDataSource.h"

#import "DWUsersController.h"
#import "DWFollowingsController.h"


@protocol DWUsersViewDataSourceDelegate;


@interface DWUsersViewDataSource : DWTableViewDataSource<DWUsersControllerDelegate,DWFollowingsControllerDelegate> {
    
    DWUsersController       *_usersController;
    DWFollowingsController  *_followingsController;
}

@property (nonatomic,strong) DWUsersController *usersController;
@property (nonatomic,strong) DWFollowingsController *followingsController;


/**
 * Override delegate type.
 */
@property (nonatomic,weak) id<DWUsersViewDataSourceDelegate,DWTableViewDataSourceDelegate,NSObject> delegate;


/**
 * Fetch the designated set of users.
 */
- (void)loadUsers;

/**
 * Toggle remote & local status of following between current user and user id.
 */
- (void)toggleFollowForUserID:(NSInteger)userID;

@end


@protocol DWUsersViewDataSourceDelegate<DWTableViewDataSourceDelegate>

@required

- (void)followingsLoaded;
- (void)followingModifiedForUserID:(NSInteger)userID toStatus:(BOOL)isActive;

@end
