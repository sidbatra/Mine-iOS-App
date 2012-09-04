//
//  DWProfileViewDataSource.h
//  Mine
//
//  Created by Siddharth Batra on 7/26/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWTableViewDataSource.h"
#import "DWPurchasesController.h"
#import "DWFollowingsController.h"
#import "DWUsersController.h"


@interface DWProfileViewDataSource : DWTableViewDataSource<DWPurchasesControllerDelegate,DWFollowingsControllerDelegate,DWUsersControllerDelegate> {
    NSInteger   _userID;
}

/**
 * UserID of the user profile.
 */
@property (nonatomic,assign) NSInteger userID;


- (void)loadUser;
- (void)loadFollowing;
- (void)loadPurchases;

@end
