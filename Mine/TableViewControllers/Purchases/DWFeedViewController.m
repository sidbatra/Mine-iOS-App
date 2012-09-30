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

#import "DWAnalyticsManager.h"


@interface DWFeedViewController() {
    BOOL _isFeedLoaded;
}

@property (nonatomic,assign) BOOL isFeedLoaded;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWFeedViewController

@synthesize isFeedLoaded = _isFeedLoaded;
@dynamic delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {        
        
        self.tableViewDataSource = [[DWFeedViewDataSource alloc] init];
        
        [self addModelPresenterForClass:[DWPagination class]
                              withStyle:kDefaultModelPresenter 
                          withPresenter:[DWPaginationPresenter class]];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];    
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidAppear:(BOOL)animated {
    [self loadFeed];
}

//----------------------------------------------------------------------------------------------------
- (void)loadFeed {
    if(self.isFeedLoaded)
        return;
    
    self.isFeedLoaded = YES;
    
    [(DWFeedViewDataSource*)self.tableViewDataSource loadFeed];
    [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Feed View"];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UIActionSheet Delegate

//----------------------------------------------------------------------------------------------------
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {	
	
    if (actionSheet.tag > 0 && buttonIndex == 0) {        
        [super actionSheet:actionSheet clickedButtonAtIndex:buttonIndex];        
        [(DWFeedViewDataSource*)self.tableViewDataSource deletePurchase:actionSheet.tag];
    }
}

@end
