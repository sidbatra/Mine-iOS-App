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
#import "DWPurchase.h"
#import "DWConstants.h"


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWFeedViewController

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {        
        
        self.tableViewDataSource = [[DWFeedViewDataSource alloc] init];
        
        [self addModelPresenterForClass:[DWPurchase class]
                              withStyle:kDefaultModelPresenter 
                          withPresenter:[DWPurchaseFeedPresenter class]];
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

@end
