//
//  DWCreationNavigationViewController.m
//  Mine
//
//  Created by Deepak Rao on 7/30/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWCreationNavigationViewController.h"
#import "DWCreatePurchaseBackgroundQueueItem.h"
#import "DWBackgroundQueue.h"
#import "DWPurchase.h"
#import "DWProduct.h"

/**
 * Private declarations
 */
@interface DWCreationNavigationViewController() {
    NSString                        *_query;
    
    DWCreationViewController        *_creationViewController;
    DWPurchaseInputViewController   *_purchaseInputViewController;
}

/**
 * Query for which the purchase is being made
 */
@property (nonatomic,copy) NSString *query;

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

@synthesize query                           = _query;
@synthesize creationViewController          = _creationViewController;
@synthesize purchaseInputViewController     = _purchaseInputViewController;
@synthesize delegate                        = _delegate;

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
- (void)productSelected:(DWProduct *)product 
              fromQuery:(NSString *)query {
    
    self.query = query;
    
    self.purchaseInputViewController            = [[DWPurchaseInputViewController alloc] initWithProduct:product];
    self.purchaseInputViewController.delegate   = self;
    
    [self.navigationController pushViewController:self.purchaseInputViewController 
                                         animated:YES];
}

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWPurchaseInputViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)postPurchase:(DWPurchase *)purchase 
             product:(DWProduct *)product 
           shareToFB:(BOOL)shareToFB 
           shareToTW:(BOOL)shareToTW 
           shareToTB:(BOOL)shareToTB {
    
    purchase.query = self.query;
    
    DWCreatePurchaseBackgroundQueueItem *item = [[DWCreatePurchaseBackgroundQueueItem alloc] initWithPurchase:purchase 
                                                                                                      product:product
                                                                                                    shareToFB:shareToFB
                                                                                                    shareToTW:shareToTW
                                                                                                    shareToTB:shareToTB];
    
    [[DWBackgroundQueue sharedDWBackgroundQueue] performSelector:@selector(addQueueItem:)      
                                                      withObject:item
                                                      afterDelay:1.5];
    
    [self.delegate dismissCreateView];
}

@end
