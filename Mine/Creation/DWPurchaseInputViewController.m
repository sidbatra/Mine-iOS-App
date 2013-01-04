//
//  DWPurchaseInputViewController.m
//  Mine
//
//  Created by Deepak Rao on 8/6/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWPurchaseInputViewController.h"
#import "DWNavigationBarBackButton.h"
#import "DWGUIManager.h"
#import "DWStore.h"
#import "DWProduct.h"
#import "DWPurchase.h"
#import "DWSetting.h"
#import "DWSession.h"
#import "DWFacebookConnect.h"
#import "DWAnalyticsManager.h"
#import "DWConstants.h"


static NSString* const kMsgIncompleteTitle      = @"Incomplete";
static NSString* const kMsgIncomplete           = @"Add the name of your item.";
static NSString* const kMsgCancelTitle          = @"Dismiss";


/**
 * Private declarations
 */
@interface DWPurchaseInputViewController () {
    BOOL                                _storePicked;
    
    DWProduct                           *_product;
    DWPurchase                          *_purchase;
    
    DWStorePickerViewController         *_storePickerViewController;
    DWFacebookConnectViewController     *_facebookConnectViewController;
    DWTwitterIOSConnect                 *_twitterIOSConnect;
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
@property (nonatomic,strong) DWTwitterIOSConnect *twitterIOSConnect;
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

@end


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWPurchaseInputViewController

@synthesize nameTextField                   = _nameTextField;
@synthesize reviewTextField                 = _reviewTextField;
@synthesize storeNameLabel                  = _storeNameLabel;
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
@synthesize twitterIOSConnect               = _twitterIOSConnect;
@synthesize tumblrConnectViewController     = _tumblrConnectViewController;
@synthesize delegate                        = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)initWithProduct:(DWProduct*)product 
          andPurchase:(DWPurchase *)purchase {
    
    self = [super init];
    
    if(self) {        
        self.product                = product;         
        self.purchase               = purchase;
        
        self.storePickerViewController              = [[DWStorePickerViewController alloc] init];
        self.storePickerViewController.delegate     = self;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem   = [DWNavigationBarBackButton backButtonForNavigationController:self.navigationController];
    self.navigationItem.titleView           = [DWGUIManager navBarTitleViewWithText:@"Share"];
    self.navigationItem.rightBarButtonItem  = [DWGUIManager navBarDoneButtonWithTarget:self];    
    
    self.navigationController.navigationBarHidden = NO;

    if(![self.purchase.query hasPrefix:@"http://"])
        self.nameTextField.text = [self.purchase.query capitalizedString];
    
    [self setupSharingUI];
    
    [self.storePickerViewController preloadStores];
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Purchase Input View"];    
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
}

//----------------------------------------------------------------------------------------------------
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Private Methods

//----------------------------------------------------------------------------------------------------
- (void)setupSharingUI {
    
    DWFacebookConnect *fbConnect = [[DWFacebookConnect alloc] init];
    
    
    if([[DWSession sharedDWSession].currentUser isFacebookAuthorized] && [fbConnect hasWritePermission]) {
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
    
    if(_storePicked) {
        DWStore *store          = [[DWStore alloc] init];
        store.name              = self.storeNameLabel.text;
        self.purchase.store     = store;
    }
    
    self.purchase.origThumbURL      = self.product.mediumImageURL;
    self.purchase.title             = self.nameTextField.text;
    self.purchase.origImageURL      = self.product.largeImageURL;
    self.purchase.sourceURL         = self.product.sourceURL;
    self.purchase.endorsement       = self.reviewTextField.text;
}

//----------------------------------------------------------------------------------------------------
- (void)post {
    if (self.nameTextField.text.length == 0) {
        
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kMsgIncompleteTitle
														message:kMsgIncomplete
													   delegate:nil
											  cancelButtonTitle:kMsgCancelTitle
											  otherButtonTitles:nil];
		[alert show];
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
	return YES;
}

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWStorePickerViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)storePicked:(NSString *)storeName {
    _storePicked = YES;
    self.storeNameLabel.text = storeName;
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Store Picked"];
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
#pragma mark DWTwitterIOSConnectDelegate

//----------------------------------------------------------------------------------------------------
- (void)twitterIOSPermissionGranted {
    [self.twitterIOSConnect startReverseAuth:self.navigationController.view];
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Twitter IOS Accepted"];
}

//----------------------------------------------------------------------------------------------------
- (void)twitterIOSNoAccountsFound {
    self.twitterConnectViewController           = [[DWTwitterConnectViewController alloc] init];
    self.twitterConnectViewController.delegate  = self;
    
    [self.navigationController pushViewController:self.twitterConnectViewController
                                         animated:YES];
}

//----------------------------------------------------------------------------------------------------
- (void)twitterIOSPermissionDenied {
    [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Twitter IOS Denied"];
}

//----------------------------------------------------------------------------------------------------
- (void)twitterIOSConfigured {
    self.twitterConfigureButton.hidden  = YES;
    
    self.twitterSwitch.hidden           = NO;
    self.twitterSwitch.on               = YES;
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
- (void)doneButtonClicked {
    [self post];
}

//----------------------------------------------------------------------------------------------------
- (IBAction)storePickerButtonClicked:(id)sender {
    [self.navigationController pushViewController:self.storePickerViewController
                                         animated:YES];
}

//----------------------------------------------------------------------------------------------------
- (IBAction)facebookConfigureButtonClicked:(id)sender {
    
    self.facebookConnectViewController          = [[DWFacebookConnectViewController alloc] init];
    self.facebookConnectViewController.delegate = self;
    
    [self.navigationController pushViewController:self.facebookConnectViewController
                                         animated:YES];
}

//----------------------------------------------------------------------------------------------------
- (IBAction)twitterConfigureButtonClicked:(id)sender {
    
    self.twitterIOSConnect = [[DWTwitterIOSConnect alloc] init];
    self.twitterIOSConnect.updateCurrentUser = YES;
    self.twitterIOSConnect.delegate = self;
    
    [self.twitterIOSConnect seekPermission];
}

//----------------------------------------------------------------------------------------------------
- (IBAction)tumblrConfigureButtonClicked:(id)sender {

    self.tumblrConnectViewController            = [[DWTumblrConnectViewController alloc] init];
    self.tumblrConnectViewController.delegate   = self;
    
    [self.navigationController pushViewController:self.tumblrConnectViewController
                                         animated:YES];    
}

@end
