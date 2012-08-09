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
#import "DWStore.h"
#import "DWProduct.h"
#import "DWPurchase.h"
#import "DWSession.h"


/**
 * Private declarations
 */
@interface DWPurchaseInputViewController () {
    DWProduct                           *_product;
    DWPurchase                          *_purchase;
    
    DWStorePickerViewController         *_storePickerViewController;
    DWFacebookConnectViewController     *_facebookConnectViewController;
    DWTwitterConnectViewController      *_twitterConnectViewController;
    DWTumblrConnectViewController       *_tumblrConnectViewController;
}

/**
 * The product selected for making a purchase
 */
@property (nonatomic,strong) DWProduct *product;

/**
 * Purchase model
 */
@property (nonatomic,strong) DWPurchase *purchase;

/** 
 * Store picker controller
 */
@property (nonatomic,strong) DWStorePickerViewController *storePickerViewController;

/** 
 * UIViewControllers for connecting with third party apps
 */
@property (nonatomic,strong) DWFacebookConnectViewController *facebookConnectViewController;
@property (nonatomic,strong) DWTwitterConnectViewController *twitterConnectViewController;
@property (nonatomic,strong) DWTumblrConnectViewController *tumblrConnectViewController;


/**
 * Create a purchase model from the user input
 */
- (void)createPurchase;

/**
 * Send the delegate a message to post the purchase with the selected
 * sharing options
 */
- (void)post;

@end


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWPurchaseInputViewController

@synthesize nameTextField                   = _nameTextField;
@synthesize storeTextField                  = _storeTextField;
@synthesize reviewTextField                 = _reviewTextField;
@synthesize storePickerButton               = _storePickerButton;

@synthesize facebookSwitch                  = _facebookSwitch;
@synthesize twitterSwitch                   = _twitterSwitch;
@synthesize tumblrSwitch                    = _tumblrSwitch;

@synthesize product                         = _product;
@synthesize purchase                        = _purchase;
@synthesize storePickerViewController       = _storePickerViewController;
@synthesize facebookConnectViewController   = _facebookConnectViewController;
@synthesize twitterConnectViewController    = _twitterConnectViewController;
@synthesize tumblrConnectViewController     = _tumblrConnectViewController;
@synthesize delegate                        = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)initWithProduct:(DWProduct*)product 
             andQuery:(NSString*)query {
    
    self = [super init];
    
    if(self) {        
        self.product        = product;   
        
        self.purchase       = [[DWPurchase alloc] init];
        self.purchase.query = query;
        
        self.storePickerViewController          = [[DWStorePickerViewController alloc] init];
        self.storePickerViewController.delegate = self;
        
        self.twitterConnectViewController   = [[DWTwitterConnectViewController alloc] init];
        self.tumblrConnectViewController    = [[DWTumblrConnectViewController alloc] init];
        self.facebookConnectViewController  = [[DWFacebookConnectViewController alloc] init];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameTextField.text = [self.purchase.query capitalizedString];
    [self.nameTextField becomeFirstResponder];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Private Methods

//----------------------------------------------------------------------------------------------------
- (void)createPurchase {  
    
    DWStore *store  = [[DWStore alloc] init];
    store.name      = self.storeTextField.text;
        
    self.purchase.store             = store;
    self.purchase.origThumbURL      = self.product.mediumImageURL;
    self.purchase.title             = self.nameTextField.text;
    self.purchase.origImageURL      = self.product.largeImageURL;
    self.purchase.sourceURL         = self.product.sourceURL;
    self.purchase.endorsement       = self.reviewTextField.text;
}

//----------------------------------------------------------------------------------------------------
- (void)post {
    if (self.nameTextField.text.length == 0 || self.storeTextField.text.length == 0) {
        NSLog(@"incomplete fields - display alert");
    }
    else {
        [self createPurchase];
        
        [self.delegate postPurchase:self.purchase 
                            product:self.product 
                          shareToFB:self.facebookSwitch.on 
                          shareToTW:self.twitterSwitch.on 
                          shareToTB:self.tumblrSwitch.on];
    }
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UITextFieldDelegate

//----------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    
	if(textField == self.storeTextField || textField == self.reviewTextField)
        [self post];
    
	return YES;
}

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWStorePickerViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)storePicked:(NSString *)storeName {
    self.storeTextField.text = storeName;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark IBActions

//----------------------------------------------------------------------------------------------------
- (IBAction)storePickerButtonClicked:(id)sender {
    [self.navigationController pushViewController:self.storePickerViewController
                                         animated:YES];
}

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
    
    if (self.tumblrSwitch.on && ![[DWSession sharedDWSession].currentUser isTumblrAuthorized])
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
