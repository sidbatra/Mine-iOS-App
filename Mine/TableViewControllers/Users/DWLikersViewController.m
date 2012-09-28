//
//  DWLikersViewController.m
//  Mine
//
//  Created by Siddharth Batra on 8/2/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWLikersViewController.h"

#import "DWLikersViewDataSource.h"
#import "DWAnalyticsManager.h"
#import "DWGUIManager.h"
#import "DWPurchase.h"
#import "DWConstants.h"


@interface DWLikersViewController () {
    DWPurchase  *_purchase;
}

/**
 * The purchase whose likers are to be displayed.
 */
@property (nonatomic,strong) DWPurchase *purchase;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWLikersViewController

@synthesize purchase = _purchase;

//----------------------------------------------------------------------------------------------------
- (id)initWithPurhcase:(DWPurchase*)purchase {
    self = [super init];
    
    if(self) {        
        
        self.purchase = purchase;
        
        self.tableViewDataSource = [[DWLikersViewDataSource alloc] init];
        ((DWLikersViewDataSource*)self.tableViewDataSource).purchaseID = self.purchase.databaseID;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [DWGUIManager navBarTitleViewWithText:@"Likes"];
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Likers View"];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors

//----------------------------------------------------------------------------------------------------
- (void)requiresFullScreenMode {
    
}

@end
