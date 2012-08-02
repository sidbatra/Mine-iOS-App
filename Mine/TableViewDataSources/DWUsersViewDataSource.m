//
//  DWUsersViewDataSource.m
//  Mine
//
//  Created by Siddharth Batra on 8/2/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWUsersViewDataSource.h"

#import "DWPurchase.h"
#import "DWLike.h"

@interface DWUsersViewDataSource() {
    DWUsersController   *_usersController;
}

/**
 * Data controller for fetching a list of users.
 */
@property (nonatomic,strong) DWUsersController *usersController;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUsersViewDataSource

@synthesize purchaseID      = _purchaseID;
@synthesize usersController = _usersController;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.usersController            = [[DWUsersController alloc] init];
        self.usersController.delegate   = self;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)loadUsers {
    [self.usersController getLikersForPurchaseID:self.purchaseID];
}

//----------------------------------------------------------------------------------------------------
- (void)loadUsersFromLikesOnPurchase:(DWPurchase*)purchase {
    NSMutableArray *users = [NSMutableArray arrayWithCapacity:[purchase.likes count]];
    
    for(DWLike *like in purchase.likes) {
        [users addObject:like.user];
    }
    
    self.objects = users;
    
    [self.delegate reloadTableView];
}

//----------------------------------------------------------------------------------------------------
- (void)refreshInitiated {
    [self loadUsers];
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
