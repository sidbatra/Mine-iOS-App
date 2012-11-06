//
//  DWUnapprovedPurchasesViewController.m
//  Mine
//
//  Created by Siddharth Batra on 11/2/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWUnapprovedPurchasesViewController.h"
#import "DWStalePurchasesViewDataSource.h"
#import "DWLivePurchasesViewDataSource.h"
#import "DWModelSet.h"
#import "DWPagination.h"
#import "DWPurchase.h"
#import "DWPurchaseProfilePresenter.h"
#import "DWPaginationPresenter.h"
#import "DWNavigationBarBackButton.h"
#import "DWNavigationBarTitleView.h"
#import "DWUnapprovedPurchasesLoadingView.h"
#import "DWGUIManager.h"
#import "DWConstants.h"


@interface DWUnapprovedPurchasesViewController () {
    DWNavigationBarTitleView *_navTitleView;
    DWImportButton *_importButton;
}

@property (nonatomic,strong) DWNavigationBarTitleView *navTitleView;
@property (nonatomic,strong) DWImportButton *importButton;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUnapprovedPurchasesViewController

@synthesize navTitleView = _navTitleView;
@synthesize importButton = _importButton;
@synthesize delegate = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)initWithModeIsLive:(BOOL)isLive {
    self = [super init];
    
    if(self) {
        
        self.tableViewDataSource = isLive ? [[DWLivePurchasesViewDataSource alloc] init] : [[DWStalePurchasesViewDataSource alloc] init];
        
        [self addModelPresenterForClass:[DWModelSet class]
                              withStyle:kPurchaseProfilePresenterStyleUnapproved
                          withPresenter:[DWPurchaseProfilePresenter class]];
        
        [self addModelPresenterForClass:[DWPagination class]
                              withStyle:kDefaultModelPresenter
                          withPresenter:[DWPaginationPresenter class]];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(purchaseGiantImageLoaded:)
                                                     name:kNImgPurchaseGiantLoaded
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
        
    [self disablePullToRefresh];
    
    self.navigationItem.leftBarButtonItem = [DWNavigationBarBackButton backButtonForNavigationController:self.navigationController];
    
    if(!self.navTitleView) {
        self.navTitleView = [[DWNavigationBarTitleView alloc] initWithFrame:CGRectMake(79,0,125,44)
                                                                      title:@"Loading..."
                                                                 andSpinner:YES];
    }
    
    if(!self.importButton) {
        self.importButton = [[DWImportButton alloc] initWithFrame:CGRectMake(221, 7, 92, 30)];
        self.importButton.delegate = self;
    }
    
    [(DWUnapprovedPurchasesViewDataSource*)self.tableViewDataSource loadPurchases];
}

//----------------------------------------------------------------------------------------------------
- (UIView*)tableLoadingView {
    CGRect frame = self.view.frame;
    return [[DWUnapprovedPurchasesLoadingView alloc] initWithFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWImportButtonDelegate

//----------------------------------------------------------------------------------------------------
- (void)importButtonClicked {
    [(DWUnapprovedPurchasesViewDataSource*)self.tableViewDataSource approveSelectedPurchases];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWUnapprovedPurchasesViewDataSourceDelegate

//----------------------------------------------------------------------------------------------------
- (void)unapprovedPurchasesFinished:(NSInteger)count {
    if(count) {
        [self.importButton enterActiveState];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                            message:@"Mine couldn't find any of your e-receipts at this time."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        alertView.tag = 0;
        [alertView show];
    }
    
    
    self.navTitleView.hidden = YES;
}

//----------------------------------------------------------------------------------------------------
- (void)unapprovedPurchasesApprovedWithCount:(NSInteger)count {
    
    [self.importButton enterInactiveState];
    
    if(count) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Import Successful"
                                                            message:@"Mine will notify you when you have new items."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        alertView.tag = count;
        [alertView show];
    }
    else {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Nothing Imported"
                                                            message:@"Mine will notify you when you have new items."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        alertView.tag = 0;
        [alertView show];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)unapprovedPurchasesApproveError {
    [self.importButton enterActiveState];
    [DWGUIManager connectionErrorAlertView];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UIAlertViewDelegate

//----------------------------------------------------------------------------------------------------
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex != 0)
        return;
    
    if(alertView.tag) {
        [self.delegate unapprovedPurchasesSuccessfullyApproved];
    }
    else {
        [self.delegate unapprovedPurchasesNoPurchasesApproved];
    }
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWPurchaseProfileCellDelegate

//----------------------------------------------------------------------------------------------------
- (void)purchaseCrossClicked:(NSInteger)purchaseID {
    [(DWUnapprovedPurchasesViewDataSource*)self.tableViewDataSource removePurchase:purchaseID];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)purchaseGiantImageLoaded:(NSNotification*)notification {
    NSDictionary *userInfo = [notification userInfo];
    
    [self provideResourceToVisibleCells:[DWPurchase class]
                               objectID:[[userInfo objectForKey:kKeyResourceID] integerValue]
                              objectKey:kKeyGiantImageURL];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors

//----------------------------------------------------------------------------------------------------
- (void)willShowOnNav {
    [self.navigationController.navigationBar addSubview:self.navTitleView];
    [self.navigationController.navigationBar addSubview:self.importButton];
}

//----------------------------------------------------------------------------------------------------
- (void)requiresFullScreenMode {
    
}

@end
