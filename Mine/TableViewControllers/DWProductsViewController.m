//
//  DWProductViewController.m
//  Mine
//
//  Created by Deepak Rao on 7/30/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWProductsViewController.h"
#import "DWProductsViewDataSource.h"
#import "DWProductPresenter.h"
#import "DWPagination.h"
#import "DWPaginationPresenter.h"
#import "DWModelSet.h"
#import "DWProduct.h"
#import "DWConstants.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWProductsViewController

@synthesize delegate = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {        

        self.tableViewDataSource = [[DWProductsViewDataSource alloc] init];
        
        [self addModelPresenterForClass:[DWModelSet class]
                              withStyle:kDefaultModelPresenter 
                          withPresenter:[DWProductPresenter class]];
        
        [self addModelPresenterForClass:[DWPagination class]
                              withStyle:kDefaultModelPresenter 
                          withPresenter:[DWPaginationPresenter class]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(productMediumImageLoaded:) 
                                                     name:kNImgProductMediumLoaded
                                                   object:nil];
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
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DataSource Methods

//----------------------------------------------------------------------------------------------------
- (void)searchProductsForQuery:(NSString *)query {
    [(DWProductsViewDataSource*)self.tableViewDataSource loadProductsForQuery:query];    
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWProductsViewDataSourceDelegate

//----------------------------------------------------------------------------------------------------
- (void)productsLoaded {
    [self.delegate productsLoaded];
}

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWProductCellDelegate

//----------------------------------------------------------------------------------------------------
- (void)productClicked:(NSNumber *)productID {

    SEL sel = @selector(productClicked:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    DWProduct *product = [DWProduct fetch:[productID integerValue]];
    
    if(product)
        [self.delegate performSelector:sel 
                            withObject:product];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)productMediumImageLoaded:(NSNotification*)notification {
    NSDictionary *userInfo = [notification userInfo];
    
    [self provideResourceToVisibleCells:[DWModelSet class] 
                               objectID:[[userInfo objectForKey:kKeyResourceID] integerValue]
                              objectKey:kKeyMediumImageURL];
}

@end

