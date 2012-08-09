//
//  DWStorePickerViewController.m
//  Mine
//
//  Created by Deepak Rao on 8/9/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWStorePickerViewController.h"
#import "DWStore.h"

/**
 * Private declarations
 */
@interface DWStorePickerViewController () {    
    DWStoresViewController    *_storesViewController;
}

/**
 * Stores View Controller for displaying store search results
 */
@property (nonatomic,strong) DWStoresViewController *storesViewController;


/** 
 * Show keyboard for searching stores
 */
- (void)showKeyboard;

/** 
 * Selector for searching stores as the user types
 */
- (void)searchStores:(NSString*)query;

/** 
 * Fired when a store is picked from the table view or 
 * added manually
 */
- (void)storePicked:(NSString*)storeName;


@end


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWStorePickerViewController

@synthesize searchTextField             = _searchTextField;
@synthesize doneButton                  = _doneButton;
@synthesize storesViewController        = _storesViewController;

@synthesize delegate                    = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(!self.storesViewController)
        self.storesViewController = [[DWStoresViewController alloc] init];
    
    self.storesViewController.delegate    = self;
    self.storesViewController.view.frame  = CGRectMake(0,50,320,400);
    
    [self.view addSubview:self.storesViewController.view];
    
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
- (void)searchStores:(NSString *)query {
    [self.storesViewController searchStoresForQuery:[query stringByTrimmingCharactersInSet:
                                                     [NSCharacterSet whitespaceAndNewlineCharacterSet]]];
}

//----------------------------------------------------------------------------------------------------
- (void)storePicked:(NSString *)storeName {
    
    [self.delegate storePicked:storeName];
    [self.navigationController popViewControllerAnimated:YES];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark IBActions

//----------------------------------------------------------------------------------------------------
- (IBAction)searchTextFieldEditingChanged:(id)sender {
    
    [self performSelectorInBackground:@selector(searchStores:) 
                           withObject:self.searchTextField.text];
}

//----------------------------------------------------------------------------------------------------
- (IBAction)doneButtonClicked:(id)sender {
    [self storePicked:self.searchTextField.text];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWStoresViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)storeSelected:(DWStore *)store {
    [self storePicked:store.name];
}

//----------------------------------------------------------------------------------------------------
- (void)storesFetched {
    self.doneButton.hidden = true;
}

//----------------------------------------------------------------------------------------------------
- (void)noStoresFetched {
    self.doneButton.hidden = false;
}


@end
