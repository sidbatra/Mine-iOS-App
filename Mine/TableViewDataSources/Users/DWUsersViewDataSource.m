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

@synthesize followingsLoaded        = _followingsLoaded;
@synthesize usersController         = _usersController;
@synthesize followingsController    = _followingsController;

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
    if(self.followingsLoaded)
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
    self.followingsLoaded = YES;
}

//----------------------------------------------------------------------------------------------------
- (void)followingsLoadError:(NSString *)message {    
}
   
@end
