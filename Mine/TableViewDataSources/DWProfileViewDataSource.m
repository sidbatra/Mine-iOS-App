//
//  DWProfileViewDataSource.m
//  Mine
//
//  Created by Siddharth Batra on 7/26/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWProfileViewDataSource.h"
#import "DWFollowingManager.h"
#import "DWPagination.h"
#import "DWModelSet.h"
#import "DWPurchase.h"
#import "DWuser.h"
#import "DWFollowing.h"
#import "DWSession.h"
#import "DWConstants.h"

 
@interface DWProfileViewDataSource() {
    DWPurchasesController   *_purchasesController;
    DWFollowingsController  *_followingsController;
    DWUsersController       *_usersController;
    
    DWUser                  *_user;
    
    NSMutableArray          *_purchases;
    
    NSInteger _oldestTimestamp;
}

/**
 * Data controller for fetching purchases.
 */
@property (nonatomic,strong) DWPurchasesController *purchasesController;

/**
 * Data controller for the followings model.
 */
@property (nonatomic,strong) DWFollowingsController *followingsController;

/**
 * Data controller for the users model.
 */
@property (nonatomic,strong) DWUsersController *usersController;

/**
 * The user whose profile is being displayed.
 */
@property (nonatomic,strong) DWUser *user;

/**
 * Holds the last page of purchases loaded from the server to break deadlocks
 * in displaying the profile view since the user cell and purchases cells must be
 * displayed together.
 */
@property (nonatomic,strong) NSMutableArray *purchases;

/**
 * Timestamp of the last item in the feed. Used to fetch more items.
 */
@property (nonatomic,assign) NSInteger oldestTimestamp;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWProfileViewDataSource

@synthesize userID                  = _userID;
@synthesize purchasesController     = _purchasesController;
@synthesize followingsController    = _followingsController;
@synthesize usersController         = _usersController;
@synthesize user                    = _user;
@synthesize purchases               = _purchases;
@synthesize oldestTimestamp         = _oldestTimestamp;
@dynamic delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.purchasesController            = [[DWPurchasesController alloc] init];
        self.purchasesController.delegate   = self;
        
        self.followingsController           = [[DWFollowingsController alloc] init];
        self.followingsController.delegate  = self;
        
        self.usersController                = [[DWUsersController alloc] init];
        self.usersController.delegate       = self;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)loadUser {
    [self.usersController getUserWithID:self.userID];
}

//----------------------------------------------------------------------------------------------------
- (void)loadFollowing {
    [self.followingsController getFollowingForUserID:self.userID];
}

//----------------------------------------------------------------------------------------------------
- (void)toggleFollowing {
    
    DWFollowing *following = [[DWFollowingManager sharedDWFollowingManager] followingForUserID:self.userID];
    
    if(following) {
        [self.followingsController destroyFollowing:following.databaseID
                                          ForUserID:self.userID];
    }
    else {
        [self.followingsController createFollowingForUserID:self.userID];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)loadPurchases {
    [self.purchasesController getPurchasesForUser:self.userID 
                                           before:self.oldestTimestamp];
}

//----------------------------------------------------------------------------------------------------
- (void)refreshInitiated {
    self.oldestTimestamp = 0;
    
    id lastObject   = [self.objects lastObject];
    
    if([lastObject isKindOfClass:[DWPagination class]]) {
        ((DWPagination*)lastObject).isDisabled = YES;
    }
    
    [self loadUser];
    [self loadFollowing];
    [self loadPurchases];
}

//----------------------------------------------------------------------------------------------------
- (void)paginate {
    [self loadPurchases];
}

//----------------------------------------------------------------------------------------------------
- (void)addObjectsFromPurchases:(NSMutableArray*)purchases
              withStartingIndex:(NSInteger)startingIndex {
    
    NSInteger count = [purchases count];
    
    for(NSInteger i=startingIndex ; i < count ; i+=kColumnsInPurchaseSearch) {        
        DWModelSet *purchaseSet = [[DWModelSet alloc] init];
        
        for (NSInteger j=0; j<kColumnsInPurchaseSearch; j++) {
            NSInteger index = i+j;
            
            if(index < count)
                [purchaseSet addModel:[purchases objectAtIndex:index]];
        }
        
        [self.objects addObject:purchaseSet];
    }
    
}

//----------------------------------------------------------------------------------------------------
- (void)displayPurchasesAndUser {
    
    if(!self.purchases || !self.user)
        return;
    
    id lastObject               = [self.objects lastObject];
    BOOL paginate               = NO;
    NSInteger startingIndex     = 0;
    
    
    if([lastObject isKindOfClass:[DWPagination class]]) {
        paginate = !((DWPagination*)lastObject).isDisabled;
    }
    
    if(!paginate) {
        [self clean];
        self.objects = [NSMutableArray array];
        [self.objects addObject:self.user];
    }
    else {
        [self.objects removeLastObject];
        
        DWModelSet *lastSet = [self.objects lastObject];
        startingIndex = kColumnsInPurchaseSearch - lastSet.length;
        
        if(startingIndex != 0 && [self.purchases count]) {
            for(NSInteger i=0 ; i < startingIndex ; i++) {
                [lastSet addModel:[self.purchases objectAtIndex:i]];
            }
        }
    }
    
    [self addObjectsFromPurchases:self.purchases
                withStartingIndex:startingIndex];
    
    
    if([self.purchases count]) {
        self.oldestTimestamp        = [((DWPurchase*)[self.purchases lastObject]).createdAt timeIntervalSince1970];
        
        DWPagination *pagination    = [[DWPagination alloc] init];
        pagination.owner            = self;
        [self.objects addObject:pagination];
    }
    
    self.purchases = nil;
    
    [self.delegate reloadTableView];

}

//----------------------------------------------------------------------------------------------------
- (void)fireFollowingLoadedDelegate:(DWFollowing*)following {
        
    [self.delegate followingLoadedAndIsActive:following ? YES : NO];
    
    [following destroy];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWPurchasesControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)purchasesLoaded:(NSMutableArray *)purchases 
                forUser:(NSNumber *)userID {
    
    if(self.userID != [userID integerValue])
        return;
    
    self.purchases = purchases;
    
    [self displayPurchasesAndUser];
}

//----------------------------------------------------------------------------------------------------
- (void)purchasesLoadError:(NSString *)error 
                   forUser:(NSNumber*)userID {

    if(self.userID != [userID integerValue])
        return;
    
    [self.delegate displayError:error
                  withRefreshUI:YES];
}

//----------------------------------------------------------------------------------------------------
- (void)purchaseCreated:(DWPurchase *)purchase 
         fromResourceID:(NSNumber *)resourceID {
    
    if(purchase.user.databaseID != self.userID)
        return;

    self.purchases = [NSMutableArray array];
    [self.purchases addObject:purchase];
    
    for(id object in self.objects) {
        if([object isKindOfClass:[DWModelSet class]]) {
            for(id purchase in [(DWModelSet*)object models]) {
                [self.purchases addObject:purchase];
            }
        }
    }
    
    //TODO - update current user's purchase count in session
    
    self.objects = nil;
    [self displayPurchasesAndUser];
}

//----------------------------------------------------------------------------------------------------
- (void)purchaseDeleted:(NSNumber *)purchaseID {
    
    DWPurchase *purchase = [DWPurchase fetch:[purchaseID integerValue]];
    
    if(purchase.user.databaseID != self.userID)
        return;
    
    self.purchases = [NSMutableArray array];
    
    for(id object in self.objects) {
        if([object isKindOfClass:[DWModelSet class]]) {
            for(id purchase in [(DWModelSet*)object models]) {
                
                if ([(DWPurchase*)purchase databaseID] != [purchaseID integerValue]) 
                    [self.purchases addObject:purchase];
                
            }
        }
    }  
    
    //TODO - update current user's purchase count in session
    
    self.objects = nil;       
    [self displayPurchasesAndUser];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWFollowingsControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)followingLoaded:(DWFollowing *)following 
              forUserID:(NSNumber *)userID {
    
    if(self.userID != [userID integerValue])
        return;
    
    [self fireFollowingLoadedDelegate:following];
}

//----------------------------------------------------------------------------------------------------
- (void)followingLoadError:(NSString *)message 
                 forUserID:(NSNumber *)userID {
    
    if(self.userID != [userID integerValue])
        return;
}

//----------------------------------------------------------------------------------------------------
- (void)followingCreated:(DWFollowing *)following forUserID:(NSNumber *)userID {
    
    if(self.userID != [userID integerValue])
        return;
    
    [self fireFollowingLoadedDelegate:following];
}

//----------------------------------------------------------------------------------------------------
- (void)followingCreateError:(NSString *)message forUserID:(NSNumber *)userID {
    
    if(self.userID != [userID integerValue])
        return;
}

//----------------------------------------------------------------------------------------------------
- (void)followingDestroyed:(DWFollowing *)following forUserID:(NSNumber *)userID {
    
    if(self.userID != [userID integerValue])
        return;
    
    [self fireFollowingLoadedDelegate:nil];
}

//----------------------------------------------------------------------------------------------------
- (void)followingDestroyError:(NSString *)message forUserID:(NSNumber *)userID {
    
    if(self.userID != [userID integerValue])
        return;
    
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWUsersControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)userLoaded:(DWUser *)user 
        withUserID:(NSNumber *)userID {
    
    if(self.userID != [userID integerValue])
        return;
    
    self.user = user;
    
    [self displayPurchasesAndUser];
}

//----------------------------------------------------------------------------------------------------
- (void)userLoadError:(NSString *)error 
           withUserID:(NSNumber *)userID {

    if(self.userID != [userID integerValue])
        return;
    
    [self.delegate displayError:error
                  withRefreshUI:YES];
}

//----------------------------------------------------------------------------------------------------
- (void)userUpdated:(DWUser *)user {
    
    if(self.userID != user.databaseID)
        return;
    
    [self.delegate reloadRowAtIndex:0];
}


@end
