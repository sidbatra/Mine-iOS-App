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
    NSInteger _purchaseID;
}

/**
 * Purchase id for which the likers are being displayed.
 */
@property (nonatomic,assign) NSInteger purchaseID;


/**
 * Fetch the designated set of users.
 */
- (void)loadUsers;

@end
