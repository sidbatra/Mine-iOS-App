//
//  DWUsersSearchViewDataSource.m
//  Mine
//
//  Created by Siddharth Batra on 8/22/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWUsersSearchViewDataSource.h"

@interface DWUsersSearchViewDataSource() {
    NSString    *_query;
    NSInteger   _resourceID;
}

/**
 * Last query searched.
 */
@property (nonatomic,copy) NSString* query;

/**
 * Resource id for the current search request.
 */
@property (nonatomic,assign) NSInteger resourceID;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUsersSearchViewDataSource

@synthesize query       = _query;
@synthesize resourceID  = _resourceID;

//----------------------------------------------------------------------------------------------------
- (void)loadUsers {
}

- (void)refreshInitiated {
    [self loadUsersForQuery:self.query];
}

//----------------------------------------------------------------------------------------------------
- (void)loadUsersForQuery:(NSString*)query {
    self.query = query;
    self.resourceID = [self.usersController getUsersForQuery:query];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWUsersControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)usersLoaded:(NSMutableArray *)users 
      forResourceID:(NSNumber *)resourceID  {
    
    if([resourceID integerValue] != self.resourceID)
        return;
    
    self.objects = users;
    
    [self.delegate reloadTableView];
}

//----------------------------------------------------------------------------------------------------
- (void)usersLoadError:(NSString *)error 
         forResourceID:(NSNumber *)resourceID {
    
    if([resourceID integerValue] != self.resourceID)
        return;
    
    [self.delegate displayError:error
                  withRefreshUI:YES];
}


@end
