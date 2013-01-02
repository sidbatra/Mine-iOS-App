//
//  DWUnapprovedPurchasesViewDataSource.h
//  Mine
//
//  Created by Siddharth Batra on 11/2/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWTableViewDataSource.h"
#import "DWPurchasesController.h"
#import "DWStore.h"


@protocol DWUnapprovedPurchasesViewDataSourceDelegate;

@interface DWUnapprovedPurchasesViewDataSource : DWTableViewDataSource<DWPurchasesControllerDelegate> {
    DWPurchasesController *_purchasesController;
    BOOL _arePurchasesFinished;
}

@property (nonatomic,strong) DWPurchasesController *purchasesController;
@property (nonatomic,assign) BOOL arePurchasesFinished;

@property (nonatomic,strong) NSMutableArray *rejectedIDs;
@property (nonatomic,readonly) NSMutableArray *selectedIDs;

@property (nonatomic,weak) id<DWTableViewDataSourceDelegate,DWUnapprovedPurchasesViewDataSourceDelegate,NSObject> delegate;


- (void)loadPurchases;
- (void)removePurchase:(NSInteger)purchaseID;
- (void)approveSelectedPurchases;

@end


@protocol DWUnapprovedPurchasesViewDataSourceDelegate

@required

- (void)unapprovedPurchasesStatus:(DWStore*)store
                         progress:(CGFloat)progress;

- (void)unapprovedPurchasesFinished:(NSInteger)count;

- (void)unapprovedPurchasesApprovedWithCount:(NSInteger)count;
- (void)unapprovedPurchasesApproveError;

@end