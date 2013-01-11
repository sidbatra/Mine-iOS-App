//
//  DWSuggestedUsersViewDataSource.m
//  Mine
//
//  Created by Siddharth Batra on 1/2/13.
//  Copyright (c) 2013 Denwen, Inc. All rights reserved.
//

#import "DWSuggestedUsersViewDataSource.h"
#import "DWUnion.h"


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWSuggestedUsersViewDataSource

//----------------------------------------------------------------------------------------------------
- (void)loadUsers {
    [super loadUsers];
    
    [self.usersController getUserSuggestions:30];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWUsersControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)userSuggestionsLoaded:(NSMutableArray *)users
                    forUserID:(NSNumber *)userID {
    
    self.objects = users;
    
    DWUnion *uni = [[DWUnion alloc] init];
    uni.title = @"Invite a friend";
    
    [self.objects addObject:uni];
    
    [self.delegate reloadTableView];
}

//----------------------------------------------------------------------------------------------------
- (void)userSuggestionsLoadError:(NSString *)error
                       forUserID:(NSNumber *)userID {
    
    [self.delegate displayError:error
                  withRefreshUI:YES];
}

@end
