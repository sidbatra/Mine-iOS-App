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
        
    DWFeedController *_feedController;
    DWPurchasesController   *_purchasesController;
    
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
@synthesize oldestTimestamp     = _oldestTimestamp;

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
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWFeedControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)feedLoaded:(NSMutableArray *)purchases {
    
    id lastObject   = [self.objects lastObject];
    BOOL paginate   = NO;
    
    if([lastObject isKindOfClass:[DWPagination class]]) {
        paginate = !((DWPagination*)lastObject).isDisabled;
    }
    
    if(!paginate) {
        [self clean];
        self.objects = purchases;
    }
    else {
        [self.objects removeLastObject];
        [self.objects addObjectsFromArray:purchases];
    }
    
    if([purchases count]) {
        
        self.oldestTimestamp        = [((DWPurchase*)[purchases lastObject]).createdAt timeIntervalSince1970];
        
        DWPagination *pagination    = [[DWPagination alloc] init];
        pagination.owner            = self;
        [self.objects addObject:pagination];
    }
    
    
    [self.delegate reloadTableView];
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
            atIndex:0
      withAnimation:UITableViewRowAnimationTop];
}

//----------------------------------------------------------------------------------------------------
- (void)purchaseDeleted:(NSNumber *)purchaseID {
    
    [self removeObject:[DWPurchase fetch:[purchaseID integerValue]] 
         withAnimation:UITableViewRowAnimationBottom];
}


@end
