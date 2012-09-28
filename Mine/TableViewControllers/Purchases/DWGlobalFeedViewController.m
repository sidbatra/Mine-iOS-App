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
#import "DWPurchaseFeedPresenter.h"
#import "DWPurchase.h"
#import "DWPagination.h"
#import "DWConstants.h"


static NSString* const kMessageTitle            = @"People share their best buys on mine";
static NSString* const kMessageSubtitle         = @"It's the ultimate way to discover great stuff.";


/**
 * Private declarations
 */
@interface DWGlobalFeedViewController() {

}

/**
 * Create a scrollable header view having the message box
 */
- (void)createHeader;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWGlobalFeedViewController

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {        
        
        self.tableViewDataSource = [[DWGlobalFeedViewDataSource alloc] init];
        
        [self addModelPresenterForClass:[DWPurchase class]
                              withStyle:kPurchaseFeedPresenterStyleDisabled 
                          withPresenter:[DWPurchaseFeedPresenter class]];
        
        [self addModelPresenterForClass:[DWPagination class]
                              withStyle:kDefaultModelPresenter 
                          withPresenter:[DWPaginationPresenter class]];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.2235 green:0.2235 blue:0.2235 alpha:1.0];
    
    [self disablePullToRefresh];
    [self createHeader];
    
    [(DWGlobalFeedViewDataSource*)self.tableViewDataSource loadFeed];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Private Methods

//----------------------------------------------------------------------------------------------------
- (void)createHeader {
    UIView *headerView                      = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 66)];
    headerView.backgroundColor              = [UIColor colorWithRed:0.2235 green:0.2235 blue:0.2235 alpha:1.0];
        
    
    UILabel *titleLabel                     = [[UILabel alloc] initWithFrame:CGRectMake(0, 13, 320, 18)];
    titleLabel.backgroundColor              = [UIColor clearColor];
    titleLabel.textColor                    = [UIColor whiteColor];
    titleLabel.textAlignment                = UITextAlignmentCenter;
    titleLabel.text                         = kMessageTitle;
    titleLabel.font                         = [UIFont fontWithName:@"HelveticaNeue-Bold" 
                                                              size:14];
    [headerView addSubview:titleLabel];
    
    
    UILabel *subtitleLabel                  = [[UILabel alloc] initWithFrame:CGRectMake(0, 34, 320, 18)];
    subtitleLabel.backgroundColor           = [UIColor clearColor]; 
    subtitleLabel.textColor                 = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    subtitleLabel.textAlignment             = UITextAlignmentCenter;
    subtitleLabel.text                      = kMessageSubtitle;
    subtitleLabel.font                      = [UIFont fontWithName:@"HelveticaNeue" 
                                                              size:14];
    [headerView addSubview:subtitleLabel];
    
    self.tableView.tableHeaderView = headerView;
}


@end