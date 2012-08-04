//
//  DWPurchaseViewDataSource.h
//  Mine
//
//  Created by Siddharth Batra on 8/4/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWTableViewDataSource.h"

@interface DWPurchaseViewDataSource : DWTableViewDataSource {
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

@end
