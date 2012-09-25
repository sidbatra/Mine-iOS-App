//
//  DWPurchaseViewDataSource.m
//  Mine
//
//  Created by Siddharth Batra on 8/4/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWPurchaseViewDataSource.h"

#import "DWPurchase.h"
#import "DWUser.h"
#import "DWSession.h"

/**
 * Private declarations.
 */
@interface DWPurchaseViewDataSource() {
    DWPurchasesController   *_purchasesController;
}

/**
 * Data controller for the purchases model.
 */
@property (nonatomic,strong) DWPurchasesController *purchasesController;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWPurchaseViewDataSource

@synthesize purchasesController     = _purchasesController;
@synthesize purchaseID              = _purchaseID;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.purchasesController = [[DWPurchasesController alloc] init];
        self.purchasesController.delegate = self;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)loadPurchase {
    DWPurchase *purchase = [DWPurchase fetch:self.purchaseID];
    [purchase incrementPointerCount];

    self.objects = [NSArray arrayWithObject:purchase];
    
    [self.delegate reloadTableView];
}

//----------------------------------------------------------------------------------------------------
- (void)deletePurchase {
    DWPurchase *purchase = [DWPurchase fetch:self.purchaseID];
    
    if(!purchase)
        return;
    
    [self.purchasesController deletePurchaseWithID:self.purchaseID];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWPurchasesControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)purchaseDeleted:(NSNumber *)purchaseID {
    
    if (self.purchaseID == [purchaseID integerValue]) {
        self.objects = nil;
        [self.delegate reloadTableView];
    }
}

@end
