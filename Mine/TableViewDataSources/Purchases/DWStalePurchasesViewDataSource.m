//
//  DWStalePurchasesViewDataSource.m
//  Mine
//
//  Created by Siddharth Batra on 11/2/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWStalePurchasesViewDataSource.h"
#import "DWPurchase.h"
#import "DWConstants.h"


@interface DWStalePurchasesViewDataSource() {
    NSInteger _oldestTimestamp;
}

@property (nonatomic,assign) NSInteger oldestTimestamp;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWStalePurchasesViewDataSource

@synthesize oldestTimestamp = _oldestTimestamp;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)loadPurchases {
    [self.purchasesController getUnapprovedStalePurchasesBefore:self.oldestTimestamp
                                                        perPage:20];
}

//----------------------------------------------------------------------------------------------------
- (void)refreshInitiated {
    self.oldestTimestamp = 0;
    
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
    
    if([purchases count]) {
        self.oldestTimestamp  = [((DWPurchase*)[purchases lastObject]).createdAt timeIntervalSince1970];
    }

    [super unapprovedPurchasesLoaded:purchases];
}

@end
