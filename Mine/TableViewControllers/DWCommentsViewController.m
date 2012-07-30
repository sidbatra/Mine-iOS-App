//
//  DWCommentsViewController.m
//  Mine
//
//  Created by Siddharth Batra on 7/30/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWCommentsViewController.h"

#import "DWCommentsViewDataSource.h"
#import "DWCommentPresenter.h"
#import "DWPurchase.h"
#import "DWComment.h"
#import "DWConstants.h"

@interface DWCommentsViewController () {
    DWPurchase  *_purchase;
}

/**
 * The purchaes whose comments are being displayed.
 */
@property (nonatomic,strong) DWPurchase *purchase;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWCommentsViewController

@synthesize purchase = _purchase;


//----------------------------------------------------------------------------------------------------
- (id)initWithPurchase:(DWPurchase*)purchase {
    self = [super init];
    
    if(self) {        
        
        self.purchase = purchase;
        
        self.tableViewDataSource = [[DWCommentsViewDataSource alloc] init];
        self.tableViewDataSource.objects = self.purchase.comments;
        
        [self addModelPresenterForClass:[DWComment class]
                              withStyle:kDefaultModelPresenter 
                          withPresenter:[DWCommentPresenter class]];
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
    
    [self disablePullToRefresh];
    
    [self reloadTableView];
}

@end
