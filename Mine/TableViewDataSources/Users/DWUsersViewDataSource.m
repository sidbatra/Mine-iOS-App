//
//  DWUsersViewDataSource.m
//  Mine
//
//  Created by Siddharth Batra on 8/2/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWUsersViewDataSource.h"

@interface DWUsersViewDataSource()
@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUsersViewDataSource

@synthesize followingsLoaded    = _followingsLoaded;
@synthesize usersController     = _usersController;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.usersController            = [[DWUsersController alloc] init];
        self.usersController.delegate   = self;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)loadFollowings {
    if(self.followingsLoaded)
        return;
    
    self.followingsLoaded = YES;
}

//----------------------------------------------------------------------------------------------------
- (void)loadUsers {
    [self loadFollowings];
}

//----------------------------------------------------------------------------------------------------
- (void)refreshInitiated {
    [self loadUsers];
}
   
@end
