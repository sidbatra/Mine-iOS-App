//
//  DWFeedViewController.m
//  Mine
//
//  Created by Siddharth Batra on 7/23/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWFeedViewController.h"

#import "DWFeedViewDataSource.h"
#import "DWPaginationPresenter.h"

#import "DWPagination.h"
#import "DWConstants.h"

#import "DWBackgroundQueue.h"
#import "DWCreatePurchaseBackgroundQueueItem.h"
#import "DWPurchase.h"
#import "DWProduct.h"
#import "DWStore.h"


@interface DWFeedViewController()
@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWFeedViewController

@dynamic delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {        
        
        self.tableViewDataSource = [[DWFeedViewDataSource alloc] init];
        
        [self addModelPresenterForClass:[DWPagination class]
                              withStyle:kDefaultModelPresenter 
                          withPresenter:[DWPaginationPresenter class]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(backgroundQueueUpdated:) 
                                                     name:kNBackgroundQueueUpdated
                                                   object:nil];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
    
    [(DWFeedViewDataSource*)self.tableViewDataSource loadFeed];
    
    
    /*
    DWStore *store = [[DWStore alloc] init];
    store.name = @"Amazon";
    
    DWPurchase *purchase = [[DWPurchase alloc] init];
    purchase.store = store;
    purchase.origThumbURL = @"http://lh6.googleusercontent.com/public/oUYvw-EOqToLWT_2TI0Il89lf8BlMBzdcW5lToxr1ociqMqMyLJHYwPVWcYLiKWrkNvaR482zh99HHO4xY1V8XA_UVYepI0znjTzERX8zo4rkTQwyUVrT9Vk-zvePewBtWqt2oEtgw9f0UjVWtCrcJIPyLNK9p_9dm6iKBDaCp21oH2Qe0p2GGYvtRan1T24Lw";
    purchase.title = @"Baseball";
    purchase.origImageURL = @"http://a712.g.akamai.net/7/712/225/1d/www.eastbay.com/images/products/zoom/14024_z.jpg";
    purchase.sourceURL = @"http://www.eastbay.com/product/model:158202/sku:14024/rawlings-official-league-baseball-rnfc/&SID=8032&inceptor=1&cm_mmc=SEO-_-Feeds-_-Froogle-_-null";
    purchase.suggestionID = 0;
    purchase.endorsement = @"WOW";
    purchase.query = @"baseball";
    
    
    DWProduct *product = [[DWProduct alloc] init];
    product.uniqueID = @"GO-17095648632575030070";
    product.title = @"Rawlings Official League Baseball RNFC";
    
    
    
    DWCreatePurchaseBackgroundQueueItem *item = [[DWCreatePurchaseBackgroundQueueItem alloc] initWithPurchase:purchase
                                                                                                      product:product
                                                                                                    shareToFB:NO
                                                                                                    shareToTW:NO
                                                                                                    shareToTB:NO];
    
    //[[DWBackgroundQueue sharedDWBackgroundQueue] addQueueItem:item];
    [[DWBackgroundQueue sharedDWBackgroundQueue] performSelector:@selector(addQueueItem:) 
                                                      withObject:item
                                                      afterDelay:3.5];*/
}




//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)backgroundQueueUpdated:(NSNotification*)notification {
    NSDictionary *info = [notification userInfo];
    
    NSLog(@"Background queue - %d %d %f",[[info objectForKey:kKeyTotalActive] integerValue],[[info objectForKey:kKeyTotalFailed] integerValue],[[info objectForKey:kKeyTotalProgress] floatValue]);
}

@end
