//
//  DWFeedViewController.m
//  Mine
//
//  Created by Siddharth Batra on 7/23/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWFeedViewController.h"

#import "DWFeedViewDataSource.h"
#import "DWPurchaseFeedPresenter.h"
#import "DWPaginationPresenter.h"
#import "DWPurchase.h"
#import "DWPagination.h"
#import "DWConstants.h"


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWFeedViewController

@synthesize delegate = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {        
        
        self.tableViewDataSource = [[DWFeedViewDataSource alloc] init];
        
        [self addModelPresenterForClass:[DWPurchase class]
                              withStyle:kDefaultModelPresenter 
                          withPresenter:[DWPurchaseFeedPresenter class]];
        
        [self addModelPresenterForClass:[DWPagination class]
                              withStyle:kDefaultModelPresenter 
                          withPresenter:[DWPaginationPresenter class]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(purchaseGiantImageLoaded:) 
                                                     name:kNImgPurchaseGiantLoaded
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(userSquareImageLoaded:) 
                                                     name:kNImgUserSquareLoaded
                                                   object:nil];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
    
    [(DWFeedViewDataSource*)self.tableViewDataSource loadFeed];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)purchaseGiantImageLoaded:(NSNotification*)notification {
    NSDictionary *userInfo = [notification userInfo];
    
    [self provideResourceToVisibleCells:[DWPurchase class] 
                               objectID:[[userInfo objectForKey:kKeyResourceID] integerValue]
                              objectKey:kKeyGiantImageURL];
}

//----------------------------------------------------------------------------------------------------
- (void)userSquareImageLoaded:(NSNotification*)notification {
    NSDictionary *userInfo = [notification userInfo];
    
    [self provideResourceToVisibleCells:[DWUser class] 
                               objectID:[[userInfo objectForKey:kKeyResourceID] integerValue]
                              objectKey:kKeySquareImageURL];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWPurchaseFeedCellDelegate

//----------------------------------------------------------------------------------------------------
- (void)userClickedForPurchaseID:(NSNumber*)purchaseID {
    
    SEL sel = @selector(feedViewUserClicked:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    DWPurchase *purchase = [DWPurchase fetch:[purchaseID integerValue]];
    
    [self.delegate performSelector:sel 
                        withObject:purchase.user];
}


@end
