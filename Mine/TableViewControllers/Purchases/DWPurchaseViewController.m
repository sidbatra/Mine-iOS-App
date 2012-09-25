//
//  DWPurchaseViewController.m
//  Mine
//
//  Created by Siddharth Batra on 8/4/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWPurchaseViewController.h"

#import "DWPurchaseViewDataSource.h"
#import "DWPurchase.h"
#import "DWConstants.h"


@interface DWPurchaseViewController () {
    DWPurchase  *_purchase;
}

/**
 * Purchase being displaued.
 */
@property (nonatomic,strong) DWPurchase *purchase;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWPurchaseViewController

@synthesize purchase = _purchase;

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

@end
