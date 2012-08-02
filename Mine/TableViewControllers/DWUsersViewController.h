//
//  DWUsersViewController.h
//  Mine
//
//  Created by Siddharth Batra on 8/2/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWTableViewController.h"

@class DWPurchase;

@interface DWUsersViewController : DWTableViewController

/**
 * Init with purchase whose likers are to be displayed.
 */
- (id)initWithPurhcase:(DWPurchase*)purchase;

@end
