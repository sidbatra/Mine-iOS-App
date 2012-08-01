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
#import "DWProductSet.h"
#import "DWConstants.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWProductsViewController


//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {        

        self.tableViewDataSource = [[DWProductsViewDataSource alloc] init];
        
        [self addModelPresenterForClass:[DWProductSet class]
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
    
    [(DWProductsViewDataSource*)self.tableViewDataSource loadProductsForQuery:@"girl with dragon tattoo"];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)productMediumImageLoaded:(NSNotification*)notification {
    NSDictionary *userInfo = [notification userInfo];
    
    [self provideResourceToVisibleCells:[DWProductSet class] 
                               objectID:[[userInfo objectForKey:kKeyResourceID] integerValue]
                              objectKey:kKeyMediumImageURL];
}

@end

