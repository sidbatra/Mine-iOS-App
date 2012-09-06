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


@interface DWUsersViewDataSource : DWTableViewDataSource<DWUsersControllerDelegate,DWFollowingsControllerDelegate> {
    BOOL                    _followingsLoaded;
    
    DWUsersController       *_usersController;
    DWFollowingsController  *_followingsController;
}

@property (nonatomic,assign) BOOL followingsLoaded;
@property (nonatomic,strong) DWUsersController *usersController;
@property (nonatomic,strong) DWFollowingsController *followingsController;


/**
 * Fetch the designated set of users.
 */
- (void)loadUsers;

@end
