//
//  DWIFollowersViewController.m
//  Mine
//
//  Created by Siddharth Batra on 8/2/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWIFollowersViewController.h"

#import "DWIFollowersViewDataSource.h"
#import "DWAnalyticsManager.h"
#import "DWGUIManager.h"
#import "DWUser.h"


@interface DWIFollowersViewController () {
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
@implementation DWIFollowersViewController

@synthesize user = _user;

//----------------------------------------------------------------------------------------------------
- (id)initWithUser:(DWUser*)user {
    self = [super init];
    
    if(self) {        
        
        self.user = user;
        
        self.tableViewDataSource = [[DWIFollowersViewDataSource alloc] init];
        ((DWIFollowersViewDataSource*)self.tableViewDataSource).userID = self.user.databaseID;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [DWGUIManager navBarTitleViewWithText:@"Following"];
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Inverse Followers View"];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors

//----------------------------------------------------------------------------------------------------
- (void)requiresFullScreenMode {
    
}


@end
