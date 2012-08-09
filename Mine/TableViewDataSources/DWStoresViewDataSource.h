//
//  DWStoresViewDataSource.h
//  Mine
//
//  Created by Deepak Rao on 8/8/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWTableViewDataSource.h"
#import "DWStoresController.h"

@protocol DWStoresViewDataSourceDelegate;


@interface DWStoresViewDataSource : DWTableViewDataSource<DWStoresControllerDelegate> {
    
}

/**
 * Redefined delegate object
 */
@property (nonatomic,weak) id<DWStoresViewDataSourceDelegate,DWTableViewDataSourceDelegate,NSObject> delegate;


/*
 * Load all stores from the server
 */
- (void)loadAllStores;

/*
 * Load stores whose name contain a given string
 */
- (void)loadStoresMatching:(NSString*)string;

@end


/**
 * Additional delegate methods for the data source
 */
@protocol DWStoresViewDataSourceDelegate<DWTableViewDataSourceDelegate>

/**
 * Fired when all the stores are loaded
 */
- (void)allStoresLoaded;

/**
 * Fired when the queried stores are loaded
 */
- (void)storesLoadedFromQuery;

/**
 * Fired when no stores are retrieved from the query
 */
- (void)noStoresLoadedFromQuery;

@end