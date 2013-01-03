//
//  DWSuggestedUsersViewController.m
//  Mine
//
//  Created by Siddharth Batra on 1/2/13.
//  Copyright (c) 2013 Denwen, Inc. All rights reserved.
//

#import "DWSuggestedUsersViewController.h"
#import "DWSuggestedUsersViewDataSource.h"

@interface DWSuggestedUsersViewController ()

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWSuggestedUsersViewController

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.tableViewDataSource = [[DWSuggestedUsersViewDataSource alloc] init];
        
        //[self addModelPresenterForClass:[DWUnion class]
        //                      withStyle:kDefaultModelPresenter
        //                  withPresenter:[DWInviteFriendPresenter class]];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
}


@end
