//
//  DWUnapprovedPurchasesViewController.m
//  Mine
//
//  Created by Siddharth Batra on 11/2/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWUnapprovedPurchasesViewController.h"
#import "DWStalePurchasesViewDataSource.h"
#import "DWLivePurchasesViewDataSource.h"
#import "DWModelSet.h"
#import "DWPagination.h"
#import "DWPurchaseProfilePresenter.h"
#import "DWPaginationPresenter.h"
#import "DWConstants.h"


@interface DWUnapprovedPurchasesViewController ()

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUnapprovedPurchasesViewController

//----------------------------------------------------------------------------------------------------
- (id)initWithModeIsLive:(BOOL)isLive {
    self = [super init];
    
    if(self) {
        
        self.tableViewDataSource = isLive ? [[DWLivePurchasesViewDataSource alloc] init] : [[DWStalePurchasesViewDataSource alloc] init];
        
        [self addModelPresenterForClass:[DWModelSet class]
                              withStyle:kPurchaseProfilePresenterStyleWithUser
                          withPresenter:[DWPurchaseProfilePresenter class]];
        
        [self addModelPresenterForClass:[DWPagination class]
                              withStyle:kDefaultModelPresenter
                          withPresenter:[DWPaginationPresenter class]];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
        
    [self disablePullToRefresh];
    
    [(DWUnapprovedPurchasesViewDataSource*)self.tableViewDataSource loadPurchases];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWUnapprovedPurchasesViewDataSourceDelegate

//----------------------------------------------------------------------------------------------------
- (void)unapprovedPurchasesFinished {
    NSLog(@"FINISHED IN HERE");
}


@end