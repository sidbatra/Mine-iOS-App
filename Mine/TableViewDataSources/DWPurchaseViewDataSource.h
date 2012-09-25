//
//  DWPurchaseViewDataSource.h
//  Mine
//
//  Created by Siddharth Batra on 8/4/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWTableViewDataSource.h"
#import "DWPurchasesController.h"

@interface DWPurchaseViewDataSource : DWTableViewDataSource<DWPurchasesControllerDelegate> {
    NSInteger   _purchaseID;
}

/**
 * The id of the purchase being displayed.
 */
@property (nonatomic,assign) NSInteger purchaseID;


/**
 * Load the purchase onto the table view.
 */
- (void)loadPurchase;

/**
 * Delete the purchase
 */
- (void)deletePurchase;

@end
