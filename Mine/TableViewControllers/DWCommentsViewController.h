//
//  DWCommentsViewController.h
//  Mine
//
//  Created by Siddharth Batra on 7/30/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWTableViewController.h"

@class DWPurchase;

@interface DWCommentsViewController : DWTableViewController


/**
 * Init with purchase whose comments are being displayed.
 */ 
- (id)initWithPurchase:(DWPurchase*)purchase;

@end
