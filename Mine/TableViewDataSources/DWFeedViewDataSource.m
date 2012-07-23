//
//  DWFeedViewDataSource.m
//  Mine
//
//  Created by Siddharth Batra on 7/23/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWFeedViewDataSource.h"

/**
 * Private declarations.
 */
@interface DWFeedViewDataSource() {
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
@implementation DWFeedViewDataSource

@synthesize feedController  = _feedController;
@synthesize oldestTimestamp = _oldestTimestamp;

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
    [self.feedController getPurchasesBefore:self.oldestTimestamp];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWFeedViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)feedLoaded:(NSMutableArray *)purchases {
    self.objects = purchases;
    
    [self.delegate reloadTableView];
    
    //for(DWPurchase *purchase in purchases) {
    //    [purchase debug];
    //}
    
    //DWPurchase *first = [purchases objectAtIndex:0];
    //[first debug];
    
    //NSLog(@"TIME - %d",(NSInteger)[first.createdAt timeIntervalSince1970]);
    //NSLog(@"TIME - %ld",);
}

//----------------------------------------------------------------------------------------------------
- (void)feedLoadError:(NSString *)error {
}


@end
