//
//  DWProfileViewDataSource.h
//  Mine
//
//  Created by Siddharth Batra on 7/26/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWTableViewDataSource.h"
#import "DWPurchasesController.h"

@interface DWProfileViewDataSource : DWTableViewDataSource<DWPurchasesControllerDelegate> {
    NSInteger   _userID;
}

/**
 * UserID of the user profile.
 */
@property (nonatomic,assign) NSInteger userID;


/**
 * Load user purchases.
 */
- (void)loadPurchases;

@end
