//
//  DWLivePurchasesViewDataSource.m
//  Mine
//
//  Created by Siddharth Batra on 11/2/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWLivePurchasesViewDataSource.h"


@interface DWLivePurchasesViewDataSource() {
    NSInteger _offset;
}

@property (nonatomic,assign) NSInteger offset;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWLivePurchasesViewDataSource

@synthesize offset = _offset;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)loadPurchases {
    [self.purchasesController getUnapprovedLivePurchasesAtOffset:self.offset
                                                         perPage:10];
}

//----------------------------------------------------------------------------------------------------
- (void)refreshInitiated {
    self.offset = 0;
    
    [super refreshInitiated];
}

//----------------------------------------------------------------------------------------------------
- (void)paginate {
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWPurchasesControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)unapprovedPurchasesLoaded:(NSMutableArray *)purchases {
    [super unapprovedPurchasesLoaded:purchases];
    
    if([purchases count]) {
        self.offset += [purchases count];
        [self loadPurchases];
    }
}

@end