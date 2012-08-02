//
//  DWFollowersViewDataSource.m
//  Mine
//
//  Created by Siddharth Batra on 8/2/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWFollowersViewDataSource.h"

#import "DWUser.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWFollowersViewDataSource

@synthesize userID  = _userID;

//----------------------------------------------------------------------------------------------------
- (void)loadUsers {
    [self.usersController getFollowersForUserID:self.userID];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWUsersControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)followersLoaded:(NSMutableArray *)users 
              forUserID:(NSNumber *)userID {
    
    if([userID integerValue] != self.userID)
        return;

    
    self.objects = users;
    
    [self.delegate reloadTableView];
}

//----------------------------------------------------------------------------------------------------
- (void)followersLoadError:(NSString *)error 
                 forUserID:(NSNumber *)userID {
    
    if([userID integerValue] != self.userID)
        return;
    
    
    [self.delegate displayError:error
                  withRefreshUI:YES];
}

@end
