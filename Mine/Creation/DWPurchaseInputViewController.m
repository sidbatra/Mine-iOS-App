//
//  DWPurchaseInputViewController.m
//  Mine
//
//  Created by Deepak Rao on 8/6/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWPurchaseInputViewController.h"
#import "DWFacebookConnectViewController.h"
#import "DWTwitterConnectViewController.h"
#import "DWTumblrConnectViewController.h"
#import "DWProduct.h"
#import "DWSession.h"


/**
 * Private declarations
 */
@interface DWPurchaseInputViewController () {
    DWProduct                           *_product;
    
    DWFacebookConnectViewController     *_facebookConnectViewController;
    DWTwitterConnectViewController      *_twitterConnectViewController;
    DWTumblrConnectViewController       *_tumblrConnectViewController;
}

/**
 * The product selected for making a purchase
 */
@property (nonatomic,strong) DWProduct *product;

/** 
 * UIViewControllers for connecting with third party apps
 */
@property (nonatomic,strong) DWFacebookConnectViewController *facebookConnectViewController;
@property (nonatomic,strong) DWTwitterConnectViewController *twitterConnectViewController;
@property (nonatomic,strong) DWTumblrConnectViewController *tumblrConnectViewController;

@end


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWPurchaseInputViewController

@synthesize facebookSwitch                  = _facebookSwitch;
@synthesize twitterSwitch                   = _twitterSwitch;
@synthesize tumblrSwitch                    = _tumblrSwitch;
@synthesize product                         = _product;
@synthesize facebookConnectViewController   = _facebookConnectViewController;
@synthesize twitterConnectViewController    = _twitterConnectViewController;
@synthesize tumblrConnectViewController     = _tumblrConnectViewController;

//----------------------------------------------------------------------------------------------------
- (id)initWithProduct:(DWProduct*)product {
    self = [super init];
    
    if(self) {        
        self.product = product;        
        
        self.twitterConnectViewController   = [[DWTwitterConnectViewController alloc] init];
        self.tumblrConnectViewController    = [[DWTumblrConnectViewController alloc] init];
        self.facebookConnectViewController  = [[DWFacebookConnectViewController alloc] init];
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
- (IBAction)facebookSwitchToggled:(id)sender {    
    
    if (self.facebookSwitch.on && ![[DWSession sharedDWSession].currentUser isFacebookAuthorized])
        [self.navigationController pushViewController:self.facebookConnectViewController 
                                             animated:YES];
}

//----------------------------------------------------------------------------------------------------
- (IBAction)twitterSwitchToggled:(id)sender {    
    
    if (self.twitterSwitch.on && ![[DWSession sharedDWSession].currentUser isTwitterAuthorized])
        [self.navigationController pushViewController:self.twitterConnectViewController 
                                             animated:YES];
}

//----------------------------------------------------------------------------------------------------
- (IBAction)tumblrSwitchToggled:(id)sender {    
    
    if (self.tumblrSwitch.on && [[DWSession sharedDWSession].currentUser isTumblrAuthorized])
        [self.navigationController pushViewController:self.tumblrConnectViewController 
                                             animated:YES];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors

//----------------------------------------------------------------------------------------------------
- (void)willShowOnNav {
    
    self.facebookSwitch.on  = [[DWSession sharedDWSession].currentUser isFacebookAuthorized]    ? YES : NO;    
    self.twitterSwitch.on   = [[DWSession sharedDWSession].currentUser isTwitterAuthorized]     ? YES : NO;
    self.tumblrSwitch.on    = [[DWSession sharedDWSession].currentUser isTumblrAuthorized]      ? YES : NO;
    
    [[DWSession sharedDWSession].currentUser debug];
}

@end
