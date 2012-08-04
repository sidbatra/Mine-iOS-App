//
//  DWPurchaseViewController.h
//  Mine
//
//  Created by Siddharth Batra on 8/4/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWPurchasesViewController.h"

@class DWPurchase;

@interface DWPurchaseViewController : DWPurchasesViewController


/**
 * Init with the purchase to be displayed.
 */
- (id)initWithPurhcase:(DWPurchase*)purchase;

@end
