//
//  DWFeedViewDataSource.m
//  Mine
//
//  Created by Siddharth Batra on 7/23/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWFeedViewDataSource.h"

#import "DWPurchase.h"
#import "DWPagination.h"

/**
 * Private declarations.
 */
@interface DWFeedViewDataSource() {
        
    DWFeedController        *_feedController;
    DWPurchasesController   *_purchasesController;
    DWUsersController       *_usersController;
    
    NSMutableArray          *_users;
    NSMutableArray          *_purchases;
    
    NSInteger _oldestTimestamp;
}

/**
 * Data controller for fetching the feed.
 */
@property (nonatomic,strong) DWFeedController* feedController;

/**
 * Data controller for the purchases model.
 */
@property (nonatomic,strong) DWPurchasesController *purchasesController;

/**
 * Data controller for the users model.
 */
@property (nonatomic,strong) DWUsersController *usersController;

/**
 * Users suggested for who to follow
 */
@property (nonatomic,strong) NSMutableArray *users;

/**
 * Holds the last page of purchases loaded from the server to break deadlocks
 * in displaying the feed since the users cell and purchases cells must be
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
@implementation DWFeedViewDataSource

@synthesize feedController      = _feedController;
@synthesize purchasesController = _purchasesController;
@synthesize usersController     = _usersController;

@synthesize users               = _users;
@synthesize purchases           = _purchases;
@synthesize oldestTimestamp     = _oldestTimestamp;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.feedController = [[DWFeedController alloc] init];
        self.feedController.delegate = self;
        
        self.purchasesController = [[DWPurchasesController alloc] init];
        self.purchasesController.delegate = self;
        
        self.usersController = [[DWUsersController alloc] init];
        self.usersController.delegate = self;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)loadFeed {
    [self.feedController getPurchasesBefore:self.oldestTimestamp];
}

//----------------------------------------------------------------------------------------------------
- (void)loadUserSuggestions {
    [self.usersController getUserSuggestions];
}

//----------------------------------------------------------------------------------------------------
- (void)deletePurchase:(NSInteger)purchaseID {
    
    DWPurchase *purchase = [DWPurchase fetch:purchaseID];
    
    if(!purchase)
        return;
    
    [self.purchasesController deletePurchaseWithID:purchaseID];
    
    [self removeObject:purchase
         withAnimation:UITableViewRowAnimationBottom];
}

//----------------------------------------------------------------------------------------------------
- (void)refreshInitiated {
    self.oldestTimestamp = 0;
    
    id lastObject   = [self.objects lastObject];
    
    if([lastObject isKindOfClass:[DWPagination class]]) {
        ((DWPagination*)lastObject).isDisabled = YES;
    }
    
    self.users = nil;
    
    [self loadUserSuggestions];
    [self loadFeed];
}

//----------------------------------------------------------------------------------------------------
- (void)paginate {
    [self loadFeed];
}

//----------------------------------------------------------------------------------------------------
- (void)displayFeedAndUserSuggestions {
    
    if(!self.purchases || !self.users)
        return;
    
    id lastObject   = [self.objects lastObject];
    BOOL paginate   = NO;
    BOOL scroll     = NO;
    
    if([lastObject isKindOfClass:[DWPagination class]]) {
        paginate = !((DWPagination*)lastObject).isDisabled;
    }
    
    if(!paginate) {
        [self clean];
        self.objects = [NSMutableArray arrayWithArray:self.users];
        scroll = YES;
    }
    else {
        [self.objects removeLastObject];
    }
    
    [self.objects addObjectsFromArray:self.purchases];
    
    if([self.purchases count]) {
        
        self.oldestTimestamp        = [((DWPurchase*)[self.purchases lastObject]).createdAt timeIntervalSince1970];
        
        DWPagination *pagination    = [[DWPagination alloc] init];
        pagination.owner            = self;
        [self.objects addObject:pagination];
    }
    
    self.purchases = nil;
    
    [self.delegate reloadTableView];
    
    if (scroll)
        [self.delegate scrollToRowAtIndex:[self.users count]];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWFeedControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)feedLoaded:(NSMutableArray *)purchases {
    self.purchases = purchases;
    [self displayFeedAndUserSuggestions];
}

//----------------------------------------------------------------------------------------------------
- (void)feedLoadError:(NSString *)error {
    [self.delegate displayError:error
                  withRefreshUI:YES];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWUsersControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)userSuggestionsLoaded:(NSMutableArray *)users forUserID:(NSNumber *)userID {
    self.users = users;
    [self displayFeedAndUserSuggestions];
}

//----------------------------------------------------------------------------------------------------
- (void)userSuggestionsLoadError:(NSString *)error forUserID:(NSNumber *)userID {
    [self.delegate displayError:error
                  withRefreshUI:YES];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWPurchasesControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)purchaseCreated:(DWPurchase *)purchase 
         fromResourceID:(NSNumber *)resourceID {
    [self addObject:purchase
            atIndex:[self.users count]
      withAnimation:UITableViewRowAnimationTop];
}

//----------------------------------------------------------------------------------------------------
- (void)purchaseDeleted:(NSNumber *)purchaseID {
    [self removeObject:[DWPurchase fetch:[purchaseID integerValue]] 
         withAnimation:UITableViewRowAnimationBottom];
}


@end
