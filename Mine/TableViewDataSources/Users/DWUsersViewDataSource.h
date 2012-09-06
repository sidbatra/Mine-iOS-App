//
//  DWUsersViewDataSource.h
//  Mine
//
//  Created by Siddharth Batra on 8/2/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWTableViewDataSource.h"

#import "DWUsersController.h"


@interface DWUsersViewDataSource : DWTableViewDataSource<DWUsersControllerDelegate> {
    BOOL                _followingsLoaded;
    
    DWUsersController   *_usersController;
}

@property (nonatomic,assign) BOOL followingsLoaded;
@property (nonatomic,strong) DWUsersController *usersController;


/**
 * Fetch the designated set of users.
 */
- (void)loadUsers;

@end
