//
//  DWLikersViewController.h
//  Mine
//
//  Created by Siddharth Batra on 8/2/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWUsersViewController.h"

@class DWPurchase;

@interface DWLikersViewController : DWUsersViewController

/**
 * Init with purchase whose likers are to be displayed.
 */
- (id)initWithPurhcase:(DWPurchase*)purchase
          loadRemotely:(BOOL)loadRemotely;

@end
