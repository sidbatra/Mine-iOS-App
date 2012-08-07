//
//  DWPurchaseInputViewController.m
//  Mine
//
//  Created by Deepak Rao on 8/6/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWPurchaseInputViewController.h"
#import "DWProduct.h"
#import "DWSession.h"


/**
 * Private declarations
 */
@interface DWPurchaseInputViewController () {
    DWProduct                           *_product;
    DWTwitterConnectViewController      *_twitterConnectViewController;
}

/**
 * The product selected for making a purchase
 */
@property (nonatomic,strong) DWProduct *product;

/** 
 * UIViewControllers for connecting with third party apps
 */
@property (nonatomic,strong) DWTwitterConnectViewController *twitterConnectViewController;

@end


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWPurchaseInputViewController

@synthesize twitterSwitch                   = _twitterSwitch;
@synthesize product                         = _product;
@synthesize twitterConnectViewController    = _twitterConnectViewController;

//----------------------------------------------------------------------------------------------------
- (id)initWithProduct:(DWProduct*)product {
    self = [super init];
    
    if(self) {        
        self.product = product;
        
        self.twitterConnectViewController = [[DWTwitterConnectViewController alloc] init];
        self.twitterConnectViewController.delegate = self;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark IBActions

//----------------------------------------------------------------------------------------------------
- (IBAction)twitterSwitchToggled:(id)sender {    
    
    if (self.twitterSwitch.on && ![[DWSession sharedDWSession].currentUser isTwitterAuthorized])
        [self.navigationController pushViewController:self.twitterConnectViewController 
                                             animated:YES];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWTwitterConnectViewController Delegate

//----------------------------------------------------------------------------------------------------
- (void)twitterAuthorized {
}

//----------------------------------------------------------------------------------------------------
- (void)twitterAuthorizationFailed {
}

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors

//----------------------------------------------------------------------------------------------------
- (void)willShowOnNav {
    self.twitterSwitch.on = [[DWSession sharedDWSession].currentUser isTwitterAuthorized] ? YES : NO;
    [[DWSession sharedDWSession].currentUser debug];
}

@end
