//
//  DWProductsViewDataSource.m
//  Mine
//
//  Created by Deepak Rao on 7/30/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWProductsViewDataSource.h"
#import "DWModelSet.h"
#import "DWProduct.h"
#import "DWConstants.h"
#import "DWPagination.h"

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

@dynamic delegate;

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
    [self refreshInitiated];
}

//----------------------------------------------------------------------------------------------------
- (void)refreshInitiated {
    self.page = 0;
    
    id lastObject   = [self.objects lastObject];
    
    if([lastObject isKindOfClass:[DWPagination class]]) {
        ((DWPagination*)lastObject).isDisabled = YES;
    }
    
    [self loadProducts];
}

//----------------------------------------------------------------------------------------------------
- (void)paginate {
    [self loadProducts];
}

//----------------------------------------------------------------------------------------------------
- (void)addObjectsFromProducts:(NSMutableArray*)products 
             withStartingIndex:(NSInteger)startingIndex {
    
    
    NSInteger count = [products count];
    
    for(NSInteger i=startingIndex ; i < count ; i+=kColumnsInProductsSearch) {        
        DWModelSet *productSet = [[DWModelSet alloc] init];
        
        for (NSInteger j=0; j<kColumnsInProductsSearch; j++) {
            NSInteger index = i+j;
            
            if(index < count)
                [productSet addModel:[products objectAtIndex:index]];
        }
        
        [self.objects addObject:productSet];
    }
    
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWProductsControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)productsLoaded:(NSMutableArray *)products 
           withQueries:(NSArray *)queries {
    
    id lastObject               = [self.objects lastObject];
    BOOL paginate               = NO;
    NSInteger startingIndex     = 0;
    
    
    if([lastObject isKindOfClass:[DWPagination class]]) {
        paginate = !((DWPagination*)lastObject).isDisabled;
    }
    
    if(!paginate) {
        [self clean];
        self.objects = [NSMutableArray array];
    }
    else {
        [self.objects removeLastObject];

        DWModelSet *lastSet = [self.objects lastObject];
        startingIndex = kColumnsInProductsSearch - lastSet.length;
        
        if(startingIndex != 0 && [products count]) {
            for(NSInteger i=0 ; i < startingIndex ; i++) {
                [lastSet addModel:[products objectAtIndex:i]];
            }
        }
    }
    
    [self addObjectsFromProducts:products 
               withStartingIndex:startingIndex];
    
    
    if([products count]) {        
        self.page++;
        
        DWPagination *pagination    = [[DWPagination alloc] init];
        pagination.owner            = self;
        [self.objects addObject:pagination];
    }
    
    
    [self.delegate reloadTableView];
    [self.delegate productsLoadedForQuery:[queries objectAtIndex:1]];
}

//----------------------------------------------------------------------------------------------------
- (void)productsLoadError:(NSString *)error {
    [self.delegate displayError:error
                  withRefreshUI:YES];
}

@end

