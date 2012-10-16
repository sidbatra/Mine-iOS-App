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
@synthesize loadRemotely            = _loadRemotely;

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
    
    if(self.loadRemotely) {
        [self.purchasesController getPurchase:self.purchaseID];
    }
    else {
        DWPurchase *purchase = [DWPurchase fetch:self.purchaseID];
        [purchase incrementPointerCount];

        self.objects = [NSArray arrayWithObject:purchase];
        
        [self.delegate reloadTableView];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)refreshInitiated {
    [self loadPurchase];
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
- (void)purchaseLoaded:(DWPurchase *)purchase
        withResourceID:(NSNumber *)resourceID {
    
    if(self.purchaseID != [resourceID integerValue])
        return;
    
    self.objects = [NSArray arrayWithObject:purchase];
    [self.delegate reloadTableView];
}

//----------------------------------------------------------------------------------------------------
- (void)purchaseLoadError:(NSString *)message
           withResourceID:(NSNumber *)resourceID {
    
    if(self.purchaseID != [resourceID integerValue])
        return;
    
    [self.delegate displayError:message
                  withRefreshUI:YES];
}

//----------------------------------------------------------------------------------------------------
- (void)purchaseDeleted:(NSNumber *)purchaseID {
    
    if (self.purchaseID == [purchaseID integerValue]) {
        self.objects = nil;
        [self.delegate reloadTableView];
    }
}

@end
