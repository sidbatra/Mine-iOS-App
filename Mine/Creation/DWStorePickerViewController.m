//
//  DWStorePickerViewController.m
//  Mine
//
//  Created by Deepak Rao on 8/9/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWStorePickerViewController.h"
#import "DWNavigationBarBackButton.h"
#import "DWGUIManager.h"
#import "DWStore.h"
#import "DWConstants.h"

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
 * Setup done button (right NavBarButton)
 */
- (void)setupDoneButton;

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
@synthesize storesViewController        = _storesViewController;

@synthesize delegate                    = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if (self) {
        self.storesViewController = [[DWStoresViewController alloc] init];
        self.storesViewController.delegate = self;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.navigationItem.leftBarButtonItem   = [DWNavigationBarBackButton backButtonForNavigationController:self.navigationController];
    self.navigationItem.titleView           = [DWGUIManager navBarTitleViewWithText:@"Pick a store"];

    self.storesViewController.view.frame = CGRectMake(0,44,320,200);
    
    [self.view addSubview:self.storesViewController.view];
    
    [self showKeyboard];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
}

//----------------------------------------------------------------------------------------------------
- (void)preloadStores {
    [self.storesViewController loadAllStores];
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
               action:@selector(doneButtonClicked)
     forControlEvents:UIControlEventTouchUpInside];
    
	[button setFrame:CGRectMake(0,0,58,30)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

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
- (void)doneButtonClicked {
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
    self.navigationItem.rightBarButtonItem = nil;
}

//----------------------------------------------------------------------------------------------------
- (void)noStoresFetched {
    [self setupDoneButton];
}


@end
