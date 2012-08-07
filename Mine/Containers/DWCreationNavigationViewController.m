//
//  DWCreationNavigationViewController.m
//  Mine
//
//  Created by Deepak Rao on 7/30/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWCreationNavigationViewController.h"

/**
 * Private declarations
 */
@interface DWCreationNavigationViewController() {
    DWCreationViewController        *_creationViewController;
    DWPurchaseInputViewController   *_purchaseInputViewController;
}

/**
 * UIViewControllers for different creation screens
 */
@property (nonatomic,strong) DWCreationViewController *creationViewController;
@property (nonatomic,strong) DWPurchaseInputViewController *purchaseInputViewController;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWCreationNavigationViewController

@synthesize creationViewController          = _creationViewController;
@synthesize purchaseInputViewController     = _purchaseInputViewController;

//----------------------------------------------------------------------------------------------------
- (void)awakeFromNib {
	[super awakeFromNib];	
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark View Lifecycle

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
    
    self.navigationItem.title = @"Create";

    if(!self.creationViewController) {
        self.creationViewController = [[DWCreationViewController alloc] init];
        self.creationViewController.delegate = self;
    }
    
    [self.view addSubview:self.creationViewController.view];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWCreationViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)productSelected:(DWProduct *)product {
    
    self.purchaseInputViewController = [[DWPurchaseInputViewController alloc] initWithProduct:product];
    
    [self.navigationController pushViewController:self.purchaseInputViewController 
                                         animated:YES];
}

@end
