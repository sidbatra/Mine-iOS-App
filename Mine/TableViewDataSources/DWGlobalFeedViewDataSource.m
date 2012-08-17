//
//  DWGlobalFeedViewDataSource.m
//  Mine
//
//  Created by Deepak Rao on 8/16/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWGlobalFeedViewDataSource.h"

#import "DWPurchase.h"
#import "DWPagination.h"

/**
 * Private declarations.
 */
@interface DWGlobalFeedViewDataSource() {
    
    DWFeedController *_feedController;      
    NSInteger _oldestTimestamp;
}

/**
 * Data controller for fetching the feed.
 */
@property (nonatomic,strong) DWFeedController* feedController;

/**
 * Timestamp of the last item in the feed. Used to fetch more items.
 */
@property (nonatomic,assign) NSInteger oldestTimestamp;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWGlobalFeedViewDataSource

@synthesize feedController      = _feedController;
@synthesize oldestTimestamp     = _oldestTimestamp;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.feedController = [[DWFeedController alloc] init];
        self.feedController.delegate = self;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)loadFeed {
    [self.feedController getGlobalPurchasesBefore:self.oldestTimestamp];
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
- (void)globalFeedLoaded:(NSMutableArray *)purchases {
    
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
- (void)globalFeedLoadError:(NSString *)error {
    [self.delegate displayError:error
                  withRefreshUI:YES];
}

@end

