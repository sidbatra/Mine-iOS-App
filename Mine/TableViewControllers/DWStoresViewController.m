//
//  DWStoresViewController.m
//  Mine
//
//  Created by Deepak Rao on 8/9/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWStoresViewController.h"
#import "DWStoresViewDataSource.h"
#import "DWStorePresenter.h"
#import "DWStore.h"
#import "DWConstants.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWStoresViewController

@synthesize delegate = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {        
        
        self.tableViewDataSource = [[DWStoresViewDataSource alloc] init];
        
        [self addModelPresenterForClass:[DWStore class]
                              withStyle:kDefaultModelPresenter 
                          withPresenter:[DWStorePresenter class]];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
    [self disablePullToRefresh];
    
    [self loadAllStores];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DataSource Methods

//----------------------------------------------------------------------------------------------------
- (void)loadAllStores {
    [(DWStoresViewDataSource*)self.tableViewDataSource loadAllStores];        
}

//----------------------------------------------------------------------------------------------------
- (void)searchStoresForQuery:(NSString *)query {
    [(DWStoresViewDataSource*)self.tableViewDataSource loadStoresMatching:query];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWStoresViewDataSourceDelegate

//----------------------------------------------------------------------------------------------------
- (void)allStoresLoaded {
    NSLog(@"all stores loaded");
}

//----------------------------------------------------------------------------------------------------
- (void)storesLoadedFromQuery {
    [self.delegate storesFetched];
}

//----------------------------------------------------------------------------------------------------
- (void)noStoresLoadedFromQuery {
    [self.delegate noStoresFetched];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Store presenter events

//----------------------------------------------------------------------------------------------------
- (void)storeClicked:(DWStore*)store {
    [self.delegate storeSelected:store];
}

@end
