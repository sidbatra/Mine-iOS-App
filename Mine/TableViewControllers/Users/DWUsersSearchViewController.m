//
//  DWUsersSearchViewController.m
//  Mine
//
//  Created by Siddharth Batra on 8/22/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWUsersSearchViewController.h"

#import "DWUsersSearchViewDataSource.h"
#import "DWUnion.h"
#import "DWInviteFriendPresenter.h"
#import "DWConstants.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUsersSearchViewController

@dynamic delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {        
        self.tableViewDataSource = [[DWUsersSearchViewDataSource alloc] init];
        
        [self addModelPresenterForClass:[DWUnion class]
                              withStyle:kDefaultModelPresenter 
                          withPresenter:[DWInviteFriendPresenter class]];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    self.loadingView.hidden = YES;
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
    
    self.tableView.backgroundColor = [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1.0];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWIniteFriendCellDelegate

//----------------------------------------------------------------------------------------------------
- (void)inviteFriendClicked {
    [self.delegate performSelector:@selector(searchViewInviteFriendClicked)];
}

@end
