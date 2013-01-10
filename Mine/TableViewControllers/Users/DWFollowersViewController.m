//
//  DWFollowersViewController.m
//  Mine
//
//  Created by Siddharth Batra on 8/2/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWFollowersViewController.h"

#import "DWFollowersViewDataSource.h"
#import "DWAnalyticsManager.h"
#import "DWGUIManager.h"
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

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self disablePullToRefresh];
    
    self.navigationItem.titleView = [DWGUIManager navBarTitleViewWithText:@"Followers"];
    
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Followers View"];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors

//----------------------------------------------------------------------------------------------------
- (void)requiresFullScreenMode {
    
}

@end
