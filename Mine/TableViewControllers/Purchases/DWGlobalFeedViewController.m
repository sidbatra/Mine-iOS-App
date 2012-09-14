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


static NSString* const kMessageTitle            = @"People use mine to share their best buys";
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
        
    [self createHeader];
    
    [(DWGlobalFeedViewDataSource*)self.tableViewDataSource loadFeed];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Private Methods

//----------------------------------------------------------------------------------------------------
- (void)createHeader {
    UIImageView *headerImageView            = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 66)];
    headerImageView.image                   = [UIImage imageNamed:kImgMessageDrawer];
        
    
    UILabel *titleLabel                     = [[UILabel alloc] initWithFrame:CGRectMake(0, 13, 320, 18)];
    titleLabel.backgroundColor              = [UIColor clearColor];
    titleLabel.shadowColor                  = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.48];
    titleLabel.shadowOffset                 = CGSizeMake(0,1);    
    titleLabel.textColor                    = [UIColor whiteColor];
    titleLabel.textAlignment                = UITextAlignmentCenter;
    titleLabel.text                         = kMessageTitle;
    titleLabel.font                         = [UIFont fontWithName:@"HelveticaNeue-Bold" 
                                                              size:14];
    [headerImageView addSubview:titleLabel];
    
    
    UILabel *subtitleLabel                  = [[UILabel alloc] initWithFrame:CGRectMake(0, 32, 320, 18)];
    subtitleLabel.backgroundColor           = [UIColor clearColor]; 
    subtitleLabel.shadowColor               = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.48];
    subtitleLabel.shadowOffset              = CGSizeMake(0,1);
    subtitleLabel.textColor                 = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];    
    subtitleLabel.textAlignment             = UITextAlignmentCenter;
    subtitleLabel.text                      = kMessageSubtitle;
    subtitleLabel.font                      = [UIFont fontWithName:@"HelveticaNeue" 
                                                              size:14];
    [headerImageView addSubview:subtitleLabel];  
    
    self.tableView.tableHeaderView = headerImageView;
}


@end