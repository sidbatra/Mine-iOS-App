//
//  DWFeedNavigationViewController.m
//  Mine
//
//  Created by Siddharth Batra on 7/25/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWFeedNavigationViewController.h"
#import "DWFeedViewController.h"
#import "DWUser.h"

#import "DWBackgroundQueue.h"
#import "DWCreatePurchaseBackgroundQueueItem.h"
#import "DWPurchase.h"
#import "DWProduct.h"
#import "DWStore.h"


@interface DWFeedNavigationViewController () {
    DWFeedViewController    *_feedViewController;
    
    DWQueueProgressView     *_queueProgressView;
    
    BOOL    _isProgressBarActive;
}

/**
 * Table view controller for displaying the feed.
 */
@property (nonatomic,strong) DWFeedViewController *feedViewController;

/**
 * Nav bar queue progress view for displaying progress from the background queue.
 */
@property (nonatomic,strong) DWQueueProgressView *queueProgressView;

/**
 * Status of the background progress queue.
 */
@property (nonatomic,assign) BOOL isProgressBarActive;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWFeedNavigationViewController

@synthesize feedViewController  = _feedViewController;
@synthesize queueProgressView   = _queueProgressView;
@synthesize isProgressBarActive = _isProgressBarActive;

//----------------------------------------------------------------------------------------------------
- (void)awakeFromNib {
	[super awakeFromNib];	
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(backgroundQueueUpdated:) 
                                                 name:kNBackgroundQueueUpdated
                                               object:nil];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark View Lifecycle

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
    
    self.navigationItem.title = @"Feed";
    
    if(!self.feedViewController) {
        self.feedViewController = [[DWFeedViewController alloc] init];
        self.feedViewController.delegate = self;
    }
    
    [self.view addSubview:self.feedViewController.view];
    
    
    
    if(!self.queueProgressView) {    
        self.queueProgressView			= [[DWQueueProgressView alloc] initWithFrame:CGRectMake(60,0,200,44)];
        self.queueProgressView.delegate	= self;
    }
    
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
- (void)viewDidUnload {
    [super viewDidUnload];
}



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)backgroundQueueUpdated:(NSNotification*)notification {
    NSDictionary *info = [notification userInfo];
	
	NSInteger totalActive	= [[info objectForKey:kKeyTotalActive] integerValue];
	NSInteger totalFailed	= [[info objectForKey:kKeyTotalFailed] integerValue];
	float totalProgress		= [[info objectForKey:kKeyTotalProgress] floatValue];
	
	
	if(totalActive || totalFailed) {
		
        if(!self.isProgressBarActive) {
            self.isProgressBarActive = YES;
            [self.navigationController.navigationBar addSubview:self.queueProgressView];
        }
		
		[self.queueProgressView updateDisplayWithTotalActive:totalActive
                                                totalFailed:totalFailed
                                              totalProgress:totalProgress];
	}
	else if(self.isProgressBarActive) {
        self.isProgressBarActive = NO;
        
        [self.queueProgressView removeFromSuperview];
    }
}



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWPostProgressViewDelegate

//----------------------------------------------------------------------------------------------------
- (void)deleteButtonPressed {
    [[DWBackgroundQueue sharedDWBackgroundQueue] deleteRequests];
}

//----------------------------------------------------------------------------------------------------
- (void)retryButtonPressed {
    [[DWBackgroundQueue sharedDWBackgroundQueue] retryRequests];
}



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWFeedViewControllerDelegate


@end
