//
//  DWUnapprovedPurchasesViewDataSource.h
//  Mine
//
//  Created by Siddharth Batra on 11/2/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWTableViewDataSource.h"
#import "DWPurchasesController.h"


@protocol DWUnapprovedPurchasesViewDataSourceDelegate;

@interface DWUnapprovedPurchasesViewDataSource : DWTableViewDataSource<DWPurchasesControllerDelegate> {
    DWPurchasesController *_purchasesController;
}

@property (nonatomic,strong) DWPurchasesController *purchasesController;
@property (nonatomic,weak) id<DWTableViewDataSourceDelegate,DWUnapprovedPurchasesViewDataSourceDelegate,NSObject> delegate;


- (void)loadPurchases;

@end


@protocol DWUnapprovedPurchasesViewDataSourceDelegate

@required

- (void)unapprovedPurchasesFinished;

@end