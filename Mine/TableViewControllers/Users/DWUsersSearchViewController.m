//
//  DWUsersSearchViewController.m
//  Mine
//
//  Created by Siddharth Batra on 8/22/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWUsersSearchViewController.h"

#import "DWUsersSearchViewDataSource.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUsersSearchViewController

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {        
        self.tableViewDataSource = [[DWUsersSearchViewDataSource alloc] init];
    }
    
    return self;
}
//----------------------------------------------------------------------------------------------------
- (void)reset {
    [self.tableViewDataSource clean];
    self.tableViewDataSource.objects = nil;
    [self reloadTableView];
}

//----------------------------------------------------------------------------------------------------
- (void)loadUsersForQuery:(NSString*)query {
    [self reset];
    self.loadingView.hidden = NO;
    [(DWUsersSearchViewDataSource*)self.tableViewDataSource loadUsersForQuery:query];
}

@end