//
//  DWFollowersViewController.m
//  Mine
//
//  Created by Siddharth Batra on 8/2/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWFollowersViewController.h"

#import "DWFollowersViewDataSource.h"
#import "DWUser.h"


@interface DWFollowersViewController () {
    DWUser  *_user;
}

/**
 * The user whose followers are being displayed.
 */
@property (nonatomic,strong) DWUser *user;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWFollowersViewController

@synthesize user = _user;

//----------------------------------------------------------------------------------------------------
- (id)initWithUser:(DWUser*)user {
    self = [super init];
    
    if(self) {        
        
        self.user = user;
        
        self.tableViewDataSource = [[DWFollowersViewDataSource alloc] init];
        ((DWFollowersViewDataSource*)self.tableViewDataSource).userID = self.user.databaseID;
    }
    
    return self;
}


@end