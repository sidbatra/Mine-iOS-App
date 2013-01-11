//
//  DWLivePurchasesViewDataSource.h
//  Mine
//
//  Created by Siddharth Batra on 11/2/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWUnapprovedPurchasesViewDataSource.h"

#import "DWUsersController.h"

@interface DWLivePurchasesViewDataSource : DWUnapprovedPurchasesViewDataSource<DWUsersControllerDelegate>

@end
