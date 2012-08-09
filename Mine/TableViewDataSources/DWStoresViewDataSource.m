//
//  DWStoresViewDataSource.m
//  Mine
//
//  Created by Deepak Rao on 8/8/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWStoresViewDataSource.h"
#import "DWStore.h"
#import "DWConstants.h"

/**
 * Private declarations.
 */
@interface DWStoresViewDataSource() {
    NSMutableArray              *_allStores;
    NSString                    *_latestQuery;
    
    DWStoresController          *_productsController;
}

/**
 * Latest query for which the stores are being fetched
 */
@property (nonatomic,copy) NSString *latestQuery;

/**
 * All Stores in the database
 */
@property (nonatomic,strong) NSMutableArray *allStores;

/**
 * Data controller for the store model.
 */
@property (nonatomic,strong) DWStoresController* storesController;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWStoresViewDataSource

@synthesize allStores           = _allStores;
@synthesize latestQuery         = _latestQuery;
@synthesize storesController    = _storesController;

@dynamic delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.storesController = [[DWStoresController alloc] init];
        self.storesController.delegate = self;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)loadAllStores {
    [self.storesController getAllStores];
}

//----------------------------------------------------------------------------------------------------
- (void)loadStoresMatching:(NSString *)string {
    self.latestQuery = string;
    
    [self.storesController getStoresForQuery:string 
                                   withCache:self.allStores];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWStoresControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)storesLoaded:(NSMutableArray *)stores {
    
    self.allStores 	= stores;
    self.objects    = stores;
    
    [self.delegate reloadTableView];
}

//----------------------------------------------------------------------------------------------------
- (void)storesLoadError:(NSString *)error {
    [self.delegate displayError:error
                  withRefreshUI:YES];
}

//----------------------------------------------------------------------------------------------------
- (void)storesLoaded:(NSMutableArray *)stores 
           fromQuery:(NSString *)query {

    if ([self.latestQuery isEqualToString:query]) {
        
        [self clean];
        self.objects = stores;
        
        if ([self.objects count]) 
            [self.delegate storesLoadedFromQuery];
        else
            [self.delegate noStoresLoadedFromQuery];
        
        [self.delegate reloadTableView];
    }
}


@end

