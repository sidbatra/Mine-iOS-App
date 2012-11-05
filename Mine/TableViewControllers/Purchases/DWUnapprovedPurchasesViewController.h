//
//  DWUnapprovedPurchasesViewController.h
//  Mine
//
//  Created by Siddharth Batra on 11/2/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWTableViewController.h"

@protocol DWUnapprovedPurchasesViewControllerDelegate;

@interface DWUnapprovedPurchasesViewController : DWTableViewController {
    __weak id<DWUnapprovedPurchasesViewControllerDelegate> _delegate;
}

@property (nonatomic,weak) id<DWUnapprovedPurchasesViewControllerDelegate> delegate;

- (id)initWithModeIsLive:(BOOL)isLive;

@end


@protocol DWUnapprovedPurchasesViewControllerDelegate

@required

- (void)unapprovedPurchasesSuccessfullyApproved;
- (void)unapprovedPurchasesNoPurchasesApproved;

@end