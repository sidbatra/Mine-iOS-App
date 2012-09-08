//
//  DWUsersViewDataSource.m
//  Mine
//
//  Created by Siddharth Batra on 8/2/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWUsersViewDataSource.h"
#import "DWFollowing.h"
#import "DWFollowingManager.h"

@interface DWUsersViewDataSource()
@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUsersViewDataSource

@synthesize usersController         = _usersController;
@synthesize followingsController    = _followingsController;
@dynamic delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.usersController            = [[DWUsersController alloc] init];
        self.usersController.delegate   = self;
        
        self.followingsController = [[DWFollowingsController alloc] init];
        self.followingsController.delegate = self;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)loadFollowings {
    if([DWFollowingManager sharedDWFollowingManager].areBulkFollowingsLoaded)
        return;
    
    [self.followingsController getFollowings];
}

//----------------------------------------------------------------------------------------------------
- (void)loadUsers {
    [self loadFollowings];
}

//----------------------------------------------------------------------------------------------------
- (void)refreshInitiated {
    [self loadUsers];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWFollowingsControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)followingsLoaded:(NSMutableArray *)followings {
    [self.delegate followingsLoaded];
}

//----------------------------------------------------------------------------------------------------
- (void)followingsLoadError:(NSString *)message {    
}
   
@end
