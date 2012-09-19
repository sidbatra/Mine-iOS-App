//
//  DWCreationViewController.m
//  Mine
//
//  Created by Deepak Rao on 8/3/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWCreationViewController.h"
#import "DWProduct.h"
#import "DWConstants.h"


/**
 * Private declarations
 */
@interface DWCreationViewController () {
    NSString                    *_query;    
    DWProduct                   *_product;        
    
    DWProductsViewController    *_productsViewController;
}

/**
 * Query for which the selected product was retrieved
 */
@property (nonatomic,copy) NSString *query;

/**
 * Product selected by the user
 */
@property (nonatomic,strong) DWProduct *product;

/**
 * Products View Controller for displaying product search results
 */
@property (nonatomic,strong) DWProductsViewController *productsViewController;


/** 
 * Show table view having search results
 */
- (void)showResults;

/** 
 * Show keyboard for searching products
 */
- (void)showKeyboard;

/** 
 * Hide keyboard
 */
- (void)hideKeyboard;

/** 
 * Show nav bar shadow
 */
- (void)showNavBarShadow;

/** 
 * Show the preview for the selected product
 */
- (void)showProductPreview;

/** 
 * Hide the product preview
 */
- (void)hideProductPreview;

/** 
 * Disable search textfield
 */
- (void)disableSearch;

/** 
 * Enable search textfield
 */
- (void)enableSearch;

/** 
 * Show loading view
 */
- (void)showLoadingView;

/** 
 * Hide loading view
 */
- (void)hideLoadingView;

@end


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWCreationViewController

@synthesize searchTextField             = _searchTextField;
@synthesize productPreview              = _productPreview;
@synthesize loadingView                 = _loadingView;
@synthesize productImageView            = _productImageView;
@synthesize topShadowView               = _topShadowView;
@synthesize productSelectButton         = _productSelectButton;
@synthesize productRejectButton         = _productRejectButton;
@synthesize cancelCreationButton        = _cancelCreationButton;
@synthesize spinner                     = _spinner;

@synthesize query                       = _query;
@synthesize product                     = _product;
@synthesize productsViewController      = _productsViewController;
@synthesize delegate                    = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init
{
    self = [super init];
    
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(productLargeImageLoaded:) 
                                                     name:kNImgProductLargeLoaded
                                                   object:nil];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(!self.productsViewController)
        self.productsViewController = [[DWProductsViewController alloc] init];
    
    self.productsViewController.delegate    = self;
    self.productsViewController.view.frame  = CGRectMake(11,44,309,416);
    self.productsViewController.view.hidden = YES;
    
    [self.view addSubview:self.productsViewController.view];
    
    [self showKeyboard];
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
- (void)showKeyboard {
    [self.searchTextField becomeFirstResponder];
}

//----------------------------------------------------------------------------------------------------
- (void)hideKeyboard {
    [self.searchTextField resignFirstResponder];
}

//----------------------------------------------------------------------------------------------------
- (void)showNavBarShadow {
    self.topShadowView.hidden = NO;
    [self.view bringSubviewToFront:self.topShadowView];
}

//----------------------------------------------------------------------------------------------------
- (void)showProductPreview {
    self.productPreview.hidden = NO;    
    [self.view bringSubviewToFront:self.productPreview];   
    
    if(!self.product.largeImage)
        self.spinner.hidden = NO;
}

//----------------------------------------------------------------------------------------------------
- (void)hideProductPreview {
    self.productPreview.hidden = YES;
}

//----------------------------------------------------------------------------------------------------
- (void)showResults {
    self.productsViewController.view.hidden = NO;
}

//----------------------------------------------------------------------------------------------------
- (void)disableSearch {
    self.searchTextField.enabled = NO;
}

//----------------------------------------------------------------------------------------------------
- (void)enableSearch {
    self.searchTextField.enabled = YES;
}

//----------------------------------------------------------------------------------------------------
- (void)showLoadingView {
    self.loadingView.hidden = NO;  
    [self.view bringSubviewToFront:self.loadingView];
}

//----------------------------------------------------------------------------------------------------
- (void)hideLoadingView {    
    self.loadingView.hidden = YES;    
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark IBAction

//----------------------------------------------------------------------------------------------------
- (void)productSelectButtonClicked:(id)sender {
    SEL sel = @selector(productSelected:fromQuery:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    [self.delegate performSelector:sel
                        withObject:self.product 
                        withObject:self.query];
}

//----------------------------------------------------------------------------------------------------
- (void)productRejectButtonClicked:(id)sender {
    self.product                = nil;
    self.productImageView.image = nil;
    
    [self hideProductPreview];
}

//----------------------------------------------------------------------------------------------------
- (void)cancelCreationButtonClicked:(id)sender {
    [self.delegate creationCancelled];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UITextFieldDelegate

//----------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    
	if(textField == self.searchTextField && self.searchTextField.text.length) {
        [self.productsViewController searchProductsForQuery:self.searchTextField.text];
        [self hideKeyboard];
        [self disableSearch];
        [self showLoadingView];
        [self.productsViewController scrollToTop];
    }
    
	return YES;
}

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWProductsViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)productsLoadedForQuery:(NSString *)query {
    self.query                  = query;
    self.searchTextField.text   = self.query;
    
    [self showResults];
    [self enableSearch];
    [self hideLoadingView];
    [self showNavBarShadow];
}

//----------------------------------------------------------------------------------------------------
- (void)productClicked:(DWProduct *)product {
    self.product = product;
    
    [self.product downloadLargeImage];    
    self.productImageView.image = self.product.largeImage;
    
    [self.view endEditing:YES];    
    [self showProductPreview];
}

//----------------------------------------------------------------------------------------------------
- (void)tableViewTouched {
    [self.view endEditing:YES];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)productLargeImageLoaded:(NSNotification*)notification {
    self.productImageView.image = self.product.largeImage;
    self.spinner.hidden = YES;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors

//----------------------------------------------------------------------------------------------------
- (void)willShowOnNav {
    
    if(!self.navigationController.navigationBarHidden)
        [self.navigationController setNavigationBarHidden:YES
                                                 animated:YES];
    
}


@end
