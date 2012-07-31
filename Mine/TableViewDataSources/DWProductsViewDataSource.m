//
//  DWProductsViewDataSource.m
//  Mine
//
//  Created by Deepak Rao on 7/30/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWProductsViewDataSource.h"
#import "DWProduct.h"

/**
 * Private declarations.
 */
@interface DWProductsViewDataSource() {
    DWProductsController *_productsController;
    
    NSString *_query;
    NSInteger _page;
}

/**
 * Data controller for fetching the products.
 */
@property (nonatomic,strong) DWProductsController* productsController;

/**
 * Query for which the products are being fetched.
 */
@property (nonatomic,copy) NSString *query;

/**
 * Timestamp of the last item in the feed. Used to fetch more items.
 */
@property (nonatomic,assign) NSInteger page;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWProductsViewDataSource

@synthesize productsController  = _productsController;
@synthesize query               = _query;
@synthesize page                = _page;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.productsController = [[DWProductsController alloc] init];
        self.productsController.delegate = self;
        
        self.page = 0;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)loadProducts {
    [self.productsController getProductsForQuery:self.query 
                                         andPage:self.page];
}

//----------------------------------------------------------------------------------------------------
- (void)loadProductsForQuery:(NSString *)query {
    self.query = query;    
    [self loadProducts];
}

//----------------------------------------------------------------------------------------------------
- (void)refreshInitiated {
    self.page = 0;
    [self loadProducts];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWProductsControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)productsLoaded:(NSMutableArray *)products 
           withQueries:(NSArray *)queries {
    
    self.objects = products;
    [self.delegate reloadTableView];
}

//----------------------------------------------------------------------------------------------------
- (void)productsLoadError:(NSString *)error {
    [self.delegate displayError:error
                  withRefreshUI:YES];
}

@end

