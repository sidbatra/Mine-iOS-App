//
//  DWGlobalFeedViewController.m
//  Mine
//
//  Created by Deepak Rao on 8/16/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWGlobalFeedViewController.h"

#import "DWGlobalFeedViewDataSource.h"
#import "DWPaginationPresenter.h"

#import "DWPagination.h"
#import "DWConstants.h"


@interface DWGlobalFeedViewController()
@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWGlobalFeedViewController

@dynamic delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {        
        
        self.tableViewDataSource = [[DWGlobalFeedViewDataSource alloc] init];
        
        [self addModelPresenterForClass:[DWPagination class]
                              withStyle:kDefaultModelPresenter 
                          withPresenter:[DWPaginationPresenter class]];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" 
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self 
                                                                             action:@selector(nextButtonClicked:)];
    
    [(DWGlobalFeedViewDataSource*)self.tableViewDataSource loadFeed];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark IBAction

//----------------------------------------------------------------------------------------------------
- (void)nextButtonClicked:(id)sender {
    SEL sel = @selector(showScreenAfterGlobalFeed);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    [self.delegate performSelector:sel];
}

@end