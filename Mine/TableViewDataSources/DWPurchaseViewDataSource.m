//
//  DWPurchaseViewDataSource.m
//  Mine
//
//  Created by Siddharth Batra on 8/4/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWPurchaseViewDataSource.h"

#import "DWPurchase.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWPurchaseViewDataSource

@synthesize purchaseID = _purchaseID;

//----------------------------------------------------------------------------------------------------
- (void)loadPurchase {
    DWPurchase *purchase = [DWPurchase fetch:self.purchaseID];

    self.objects = [NSArray arrayWithObject:purchase];
    
    [self.delegate reloadTableView];
}

@end
