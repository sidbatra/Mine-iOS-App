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
 * Show keyboard for searching products
 */
- (void)showKeyboard;

/** 
 * Hide keyboard
 */
- (void)hideKeyboard;

/** 
 * Show the preview for the selected product
 */
- (void)showProductPreview;

/** 
 * Hide the product preview
 */
- (void)hideProductPreview;

@end


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWCreationViewController

@synthesize searchTextField             = _searchTextField;
@synthesize productPreview              = _productPreview;
@synthesize productImageView            = _productImageView;
@synthesize productSelectButton         = _productSelectButton;
@synthesize productRejectButton         = _productRejectButton;

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
    self.productsViewController.view.frame  = CGRectMake(0,50,320,400);
    
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
- (void)showProductPreview {
    self.productPreview.hidden = false;
    [self.view bringSubviewToFront:self.productPreview];
}

//----------------------------------------------------------------------------------------------------
- (void)hideProductPreview {
    self.productPreview.hidden = true;
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
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UITextFieldDelegate

//----------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    
	if(textField == self.searchTextField)
        [self.productsViewController searchProductsForQuery:self.searchTextField.text];
    
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
    
    [self hideKeyboard];
}

//----------------------------------------------------------------------------------------------------
- (void)productClicked:(DWProduct *)product {
    self.product = product;
    
    [self.product downloadLargeImage];    
    self.productImageView.image = self.product.largeImage;
    
    [self showProductPreview];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)productLargeImageLoaded:(NSNotification*)notification {
    self.productImageView.image = self.product.largeImage;
}

@end
