//
//  DWPurchaseInputViewController.m
//  Mine
//
//  Created by Deepak Rao on 8/6/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWPurchaseInputViewController.h"
#import "DWNavigationBarBackButton.h"
#import "DWStore.h"
#import "DWProduct.h"
#import "DWPurchase.h"
#import "DWSetting.h"
#import "DWSession.h"


static NSString* const kImgDoneOff    = @"nav-btn-done-off@2x.png";
static NSString* const kImgDoneOn     = @"nav-btn-done-on@2x.png";

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

/**
 * Setup the UI (switch vs button) for the fb,tw and tumblr switches
 */
- (void)setupSharingUI;

/**
 * Setup done button (right NavBarButton)
 */
- (void)setupDoneButton;

@end


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWPurchaseInputViewController

@synthesize nameTextField                   = _nameTextField;
@synthesize storeTextField                  = _storeTextField;
@synthesize reviewTextField                 = _reviewTextField;
@synthesize storePickerButton               = _storePickerButton;

@synthesize facebookConfigureButton         = _facebookConfigureButton;
@synthesize twitterConfigureButton          = _twitterConfigureButton;
@synthesize tumblrConfigureButton           = _tumblrConfigureButton;

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
        
        self.storePickerViewController              = [[DWStorePickerViewController alloc] init];
        self.storePickerViewController.delegate     = self;
        
        self.facebookConnectViewController          = [[DWFacebookConnectViewController alloc] init];
        self.facebookConnectViewController.delegate = self;
        
        self.twitterConnectViewController           = [[DWTwitterConnectViewController alloc] init];
        self.twitterConnectViewController.delegate  = self;
        
        self.tumblrConnectViewController            = [[DWTumblrConnectViewController alloc] init];
        self.tumblrConnectViewController.delegate   = self;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [DWNavigationBarBackButton backButtonForNavigationController:self.navigationController];
    self.navigationController.navigationBarHidden = NO;
    
    [self setupDoneButton];
    
    self.nameTextField.text = [self.purchase.query capitalizedString];
    [self.nameTextField becomeFirstResponder];
    
    [self setupSharingUI];
    
    [self.storePickerViewController preloadStores];
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
- (void)setupDoneButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];    
    
    [button setBackgroundImage:[UIImage imageNamed:kImgDoneOff] 
                      forState:UIControlStateNormal];
    
    [button setBackgroundImage:[UIImage imageNamed:kImgDoneOn] 
                      forState:UIControlStateHighlighted];
    
	[button addTarget:self
               action:@selector(post)
     forControlEvents:UIControlEventTouchUpInside];
    
	[button setFrame:CGRectMake(0,0,58,30)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

//----------------------------------------------------------------------------------------------------
- (void)setupSharingUI {    
    
    if([[DWSession sharedDWSession].currentUser isFacebookAuthorized]) {
        self.facebookConfigureButton.hidden = YES;
        
        self.facebookSwitch.hidden  = NO; 
        self.facebookSwitch.on      = [DWSession sharedDWSession].currentUser.setting.shareToFacebook   ? YES : NO;            
    }
    
    if([[DWSession sharedDWSession].currentUser isTwitterAuthorized]) {
        self.twitterConfigureButton.hidden = YES;
        
        self.twitterSwitch.hidden   = NO; 
        self.twitterSwitch.on       = [DWSession sharedDWSession].currentUser.setting.shareToTwitter    ? YES : NO;            
    }
    
    if([[DWSession sharedDWSession].currentUser isTumblrAuthorized]) {
        self.tumblrConfigureButton.hidden = YES;
        
        self.tumblrSwitch.hidden    = NO; 
        self.tumblrSwitch.on        = [DWSession sharedDWSession].currentUser.setting.shareToTumblr     ? YES : NO;            
    }
}

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
#pragma mark DWFacebookConnectViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)facebookConfigured {
    self.facebookConfigureButton.hidden = YES;
    
    self.facebookSwitch.hidden          = NO;
    self.facebookSwitch.on              = YES;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWTwitterConnectViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)twitterConfigured {
    self.twitterConfigureButton.hidden  = YES;
    
    self.twitterSwitch.hidden           = NO;
    self.twitterSwitch.on               = YES;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWTumblrConnectViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)tumblrConfigured {
    self.tumblrConfigureButton.hidden   = YES;
    
    self.tumblrSwitch.hidden            = NO;
    self.tumblrSwitch.on                = YES;
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
- (IBAction)facebookConfigureButtonClicked:(id)sender {
    [self.navigationController pushViewController:self.facebookConnectViewController 
                                         animated:YES];
}

//----------------------------------------------------------------------------------------------------
- (IBAction)twitterConfigureButtonClicked:(id)sender {
    [self.navigationController pushViewController:self.twitterConnectViewController 
                                         animated:YES];    
}

//----------------------------------------------------------------------------------------------------
- (IBAction)tumblrConfigureButtonClicked:(id)sender {
    [self.navigationController pushViewController:self.tumblrConnectViewController 
                                         animated:YES];    
}

@end
