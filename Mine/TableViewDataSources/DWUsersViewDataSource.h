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
    DWUsersController   *_usersController;
}

/**
 * Data controller for fetching a list of users.
 */
@property (nonatomic,strong) DWUsersController *usersController;


/**
 * Fetch the designated set of users.
 */
- (void)loadUsers;

@end
