//
//  DWCreationViewController.m
//  Mine
//
//  Created by Deepak Rao on 8/3/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWCreationViewController.h"

/**
 * Private declarations
 */
@interface DWCreationViewController () {
    DWProductsViewController  *_productsViewController;
}

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

@end


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWCreationViewController

@synthesize searchTextField             = _searchTextField;
@synthesize productsViewController      = _productsViewController;

//----------------------------------------------------------------------------------------------------
- (id)init
{
    self = [super init];
    
    if (self) {

    }
    
    return self;
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
- (void)productsLoaded {
    [self hideKeyboard];
}

@end
