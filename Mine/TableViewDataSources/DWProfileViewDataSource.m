//
//  DWProfileViewDataSource.m
//  Mine
//
//  Created by Siddharth Batra on 7/26/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWProfileViewDataSource.h"
#import "DWPagination.h"
#import "DWModelSet.h"
#import "DWPurchase.h"
#import "DWuser.h"
#import "DWConstants.h"

 
@interface DWProfileViewDataSource() {
    DWPurchasesController   *_purchasesController;
    DWFollowingsController  *_followingsController;
    DWUsersController       *_usersController;
    
    DWUser                  *_user;
    
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
@synthesize oldestTimestamp         = _oldestTimestamp;

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
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWPurchasesControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)purchasesLoaded:(NSMutableArray *)purchases 
                forUser:(NSNumber *)userID {
    
    if(self.userID != [userID integerValue])
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
    }
    else {
        [self.objects removeLastObject];
        
        DWModelSet *lastSet = [self.objects lastObject];
        startingIndex = kColumnsInPurchaseSearch - lastSet.length;
        
        if(startingIndex != 0 && [purchases count]) {
            for(NSInteger i=0 ; i < startingIndex ; i++) {
                [lastSet addModel:[purchases objectAtIndex:i]];
            }
        }
    }
    
    [self addObjectsFromPurchases:purchases
               withStartingIndex:startingIndex];
    
    
    if([purchases count]) {        
        self.oldestTimestamp        = [((DWPurchase*)[purchases lastObject]).createdAt timeIntervalSince1970];
        
        DWPagination *pagination    = [[DWPagination alloc] init];
        pagination.owner            = self;
        [self.objects addObject:pagination];
    }
    
    [self.delegate reloadTableView];
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
    
    [self refreshInitiated];
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
    
    if(following)
        NSLog(@"Following active");
    else
        NSLog(@"Following inactive");
}

//----------------------------------------------------------------------------------------------------
- (void)followingLoadError:(NSString *)message 
                 forUserID:(NSNumber *)userID {
    
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
    
    [self.user debug];
}

//----------------------------------------------------------------------------------------------------
- (void)userLoadError:(NSString *)error 
           withUserID:(NSNumber *)userID {

    if(self.userID != [userID integerValue])
        return;
    
    NSLog(@"user load error");
}


@end
