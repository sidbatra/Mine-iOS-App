//
//  DWIFollowersViewDataSource.m
//  Mine
//
//  Created by Siddharth Batra on 8/2/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWIFollowersViewDataSource.h"

#import "DWUser.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWIFollowersViewDataSource

@synthesize userID  = _userID;

//----------------------------------------------------------------------------------------------------
- (void)loadUsers {
    [self.usersController getIFollowersForUserID:self.userID];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWUsersControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)ifollowersLoaded:(NSMutableArray *)users 
               forUserID:(NSNumber *)userID {
    
    if([userID integerValue] != self.userID)
        return;
    
    
    self.objects = users;
    
    [self.delegate reloadTableView];
}

//----------------------------------------------------------------------------------------------------
- (void)ifollowersLoadError:(NSString *)error 
                  forUserID:(NSNumber *)userID {
    
    if([userID integerValue] != self.userID)
        return;
    
    
    [self.delegate displayError:error
                  withRefreshUI:YES];
}
@end
