//
//  DWUnapprovedPurchasesViewDataSource.h
//  Mine
//
//  Created by Siddharth Batra on 11/2/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWTableViewDataSource.h"
#import "DWPurchasesController.h"

@interface DWUnapprovedPurchasesViewDataSource : DWTableViewDataSource<DWPurchasesControllerDelegate> {
    DWPurchasesController *_purchasesController;
}

@property (nonatomic,strong) DWPurchasesController *purchasesController;


- (void)loadPurchases;

@end
