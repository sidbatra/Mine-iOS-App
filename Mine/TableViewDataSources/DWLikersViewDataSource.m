//
//  DWLikersViewDataSource.m
//  Mine
//
//  Created by Siddharth Batra on 8/2/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWLikersViewDataSource.h"

#import "DWPurchase.h"
#import "DWLike.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWLikersViewDataSource

@synthesize purchaseID = _purchaseID;

//----------------------------------------------------------------------------------------------------
- (void)loadUsers {
    DWPurchase *purchase = [DWPurchase fetch:self.purchaseID];
    
    NSMutableArray *users = [NSMutableArray arrayWithCapacity:[purchase.likes count]];
    
    for(DWLike *like in purchase.likes) {
        [users addObject:like.user];
    }
    
    self.objects = users;
    
    [self.delegate reloadTableView];
    
    
    //[self.usersController getLikersForPurchaseID:self.purchaseID];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWUsersControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)likersLoaded:(NSMutableArray *)users 
       forPurchaseID:(NSNumber*)purchaseID {
    
    if([purchaseID integerValue] != self.purchaseID)
        return;
    
    self.objects = users;
    
    [self.delegate reloadTableView];
}

//----------------------------------------------------------------------------------------------------
- (void)likersLoadError:(NSString *)error
          forPurchaseID:(NSNumber*)purchaseID {
    
    if([purchaseID integerValue] != self.purchaseID)
        return;
    
    [self.delegate displayError:error
                  withRefreshUI:YES];
}


@end
