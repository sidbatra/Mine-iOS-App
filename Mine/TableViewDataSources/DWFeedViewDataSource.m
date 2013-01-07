//
//  DWFeedViewDataSource.m
//  Mine
//
//  Created by Siddharth Batra on 7/23/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWFeedViewDataSource.h"

#import "DWPurchase.h"
#import "DWFollowing.h"
#import "DWUnion.h"
#import "DWSession.h"
#import "DWFollowingManager.h"
#import "DWPagination.h"

static NSInteger const kEmailConnectIndex = 0;


/**
 * Private declarations.
 */
@interface DWFeedViewDataSource() {
        
    DWFeedController        *_feedController;
    DWPurchasesController   *_purchasesController;
    
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

@synthesize feedController          = _feedController;
@synthesize purchasesController     = _purchasesController;

@synthesize purchases               = _purchases;
@synthesize oldestTimestamp         = _oldestTimestamp;

@dynamic delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.feedController = [[DWFeedController alloc] init];
        self.feedController.delegate = self;
        
        self.purchasesController = [[DWPurchasesController alloc] init];
        self.purchasesController.delegate = self;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)loadFeed {
    [self.feedController getPurchasesBefore:self.oldestTimestamp];
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
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Private Methods

//----------------------------------------------------------------------------------------------------
- (void)refreshInitiated {
    self.oldestTimestamp = 0;
    
    id lastObject   = [self.objects lastObject];
    
    if([lastObject isKindOfClass:[DWPagination class]]) {
        ((DWPagination*)lastObject).isDisabled = YES;
    }
    
    [self loadFeed];
}

//----------------------------------------------------------------------------------------------------
- (void)paginate {
    [self loadFeed];
}

//----------------------------------------------------------------------------------------------------
- (void)displayFeed {
    
    if(!self.purchases)
        return;
    
    id lastObject   = [self.objects lastObject];
    BOOL paginate   = NO;
    BOOL scroll     = NO;
    
    if([lastObject isKindOfClass:[DWPagination class]]) {
        paginate = !((DWPagination*)lastObject).isDisabled;
    }
    
    if(!paginate) {
        [self clean];
        self.objects = [NSMutableArray array];

        [self addEmailConnectObject];
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
        [self.delegate scrollToRowAtIndex:kEmailConnectIndex+1];
}


//----------------------------------------------------------------------------------------------------
- (void)addEmailConnectObject {
    DWUser *user = [DWSession sharedDWSession].currentUser;
    DWUnion *uni = [[DWUnion alloc] init];
    
    if(user.isEmailAuthorized) {
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"e"];
        
        NSInteger days = (7 - [[dateFormatter stringFromDate:[NSDate date]] integerValue]  + 4) % 7;
        
        if(days == 0)
            days = 7;
        
        uni.title       = @"Connected";
        uni.subtitle    = [NSString stringWithFormat:@"Next check: %d %@",days,(days == 1 ? @"day" : @"days")];
    }
    else {
        uni.title       = @"Start your Mine";
        uni.subtitle    = @"Connect an email";
    }
    
    [uni setCustomKeyValue:kKeyIsGoogleAuthorized value:[NSNumber numberWithBool:user.isGoogleAuthorized]];
    [uni setCustomKeyValue:kKeyIsYahooAuthorized value:[NSNumber numberWithBool:user.isYahooAuthorized]];
    [uni setCustomKeyValue:kKeyIsHotmailAuthorized value:[NSNumber numberWithBool:user.isHotmailAuthorized]];
    
    
    [self.objects insertObject:uni
                       atIndex:kEmailConnectIndex];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWFeedControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)feedLoaded:(NSMutableArray *)purchases {
    self.purchases = purchases;
    [self displayFeed];
}

//----------------------------------------------------------------------------------------------------
- (void)feedLoadError:(NSString *)error {
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
            atIndex:kEmailConnectIndex+1
      withAnimation:UITableViewRowAnimationTop];
}

//----------------------------------------------------------------------------------------------------
- (void)purchaseDeleted:(NSNumber *)purchaseID {
    [self removeObject:[DWPurchase fetch:[purchaseID integerValue]] 
         withAnimation:UITableViewRowAnimationBottom];
}


@end
