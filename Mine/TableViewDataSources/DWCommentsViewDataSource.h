//
//  DWCommentsViewDataSource.h
//  Mine
//
//  Created by Siddharth Batra on 7/30/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWTableViewDataSource.h"
#import "DWCommentsController.h"


@interface DWCommentsViewDataSource : DWTableViewDataSource<DWCommentsControllerDelegate>

- (id)initWithPurchaseID:(NSInteger)purchaseID
            loadRemotely:(BOOL)loadRemotely;

- (void)loadComments;

@end
