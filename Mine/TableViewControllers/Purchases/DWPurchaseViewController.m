//
//  DWPurchaseViewController.m
//  Mine
//
//  Created by Siddharth Batra on 8/4/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWPurchaseViewController.h"

#import "DWPurchaseViewDataSource.h"
#import "DWNavigationBarTitleView.h"
#import "DWNavigationBarBackButton.h"
#import "DWPurchase.h"
#import "DWConstants.h"


@interface DWPurchaseViewController () {
    DWPurchase                  *_purchase;    
    DWNavigationBarTitleView    *_navTitleView;
}

/**
 * Purchase being displaued.
 */
@property (nonatomic,strong) DWPurchase *purchase;

/**
 * Tile view inserted onto the navigation bar.
 */
@property (nonatomic,strong) DWNavigationBarTitleView *navTitleView;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWPurchaseViewController

@synthesize purchase        = _purchase;
@synthesize navTitleView    = _navTitleView;

//----------------------------------------------------------------------------------------------------
- (id)initWithPurhcase:(DWPurchase*)purchase {
    self = [super init];
    
    if(self) {        
        
        self.purchase = purchase;
        
        self.tableViewDataSource = [[DWPurchaseViewDataSource alloc] init];
        ((DWPurchaseViewDataSource*)self.tableViewDataSource).purchaseID = self.purchase.databaseID;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem   = [DWNavigationBarBackButton backButtonForNavigationController:self.navigationController];
    self.navigationItem.title               = @"";
    
    if(!self.navTitleView)
        self.navTitleView = [DWNavigationBarTitleView logoTitleView];

    
    [(DWPurchaseViewDataSource*)self.tableViewDataSource loadPurchase];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UIActionSheet Delegate

//----------------------------------------------------------------------------------------------------
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {	
	
    if (actionSheet.tag == self.purchase.databaseID && buttonIndex == 0) {
        
        [super actionSheet:actionSheet clickedButtonAtIndex:buttonIndex];
        
        [(DWPurchaseViewDataSource*)self.tableViewDataSource deletePurchase];
        
        if (self.navigationController.topViewController == self) 
            [self.navigationController popViewControllerAnimated:YES];
    }
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors

//----------------------------------------------------------------------------------------------------
- (void)willShowOnNav {    
    [self.navigationController.navigationBar addSubview:self.navTitleView];
}

//----------------------------------------------------------------------------------------------------
- (void)requiresFullScreenMode {
    
}

@end
