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
#import "DWAnalyticsManager.h"
#import "DWConstants.h"


@interface DWUnapprovedPurchasesViewController () {
    DWQueueProgressView  *_progressView;
    DWImportButton *_importButton;
    UIActivityIndicatorView *_spinner;
    UIImageView *_storeLogo;
    
    BOOL _isLive;
    BOOL _isUpdate;
}

@property (nonatomic,strong) DWQueueProgressView *progressView;
@property (nonatomic,strong) DWImportButton *importButton;
@property (nonatomic,strong) UIActivityIndicatorView *spinner;
@property (nonatomic,strong) UIImageView *storeLogo;
@property (nonatomic,assign) BOOL isLive;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUnapprovedPurchasesViewController

@synthesize progressView = _progressView;
@synthesize importButton = _importButton;
@synthesize spinner = _spinner;
@synthesize storeLogo = _storeLogo;
@synthesize isLive = _isLive;
@synthesize isUpdate = _isUpdate;
@synthesize delegate = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)initWithModeIsLive:(BOOL)isLive {
    self = [super init];
    
    if(self) {
        
        self.isLive = isLive;
        
        self.tableViewDataSource = self.isLive ? [[DWLivePurchasesViewDataSource alloc] init] : [[DWStalePurchasesViewDataSource alloc] init];
        
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
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(storeMediumImageLoaded:)
                                                     name:kNImgStoreMediumLoaded
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
    
    if(!self.progressView) {
        self.progressView = [[DWQueueProgressView alloc] initWithFrame:CGRectMake(60,0,200,44)];
        self.progressView.delegate	= self;
        [self.progressView removeInteractiveElements];
        
        [self.progressView updateDisplayWithTotalActive:1 totalFailed:0 totalProgress:1.0];
    }
    
    if(!self.spinner) {
        self.spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(280,12,20,20)];
        self.spinner.hidesWhenStopped = YES;
        [self.spinner startAnimating];
    }
    
    if(!self.storeLogo) {
        self.storeLogo = [[UIImageView alloc] initWithFrame:CGRectMake(99+10,6,122,32)];
        self.storeLogo.contentMode = UIViewContentModeScaleAspectFit;
        self.storeLogo.hidden = YES;
    }
    
    if(!self.importButton) {
        self.importButton = [[DWImportButton alloc] initWithFrame:self.isUpdate ? CGRectMake(223, 7, 90, 30) : CGRectMake(193,7,120,30)];
        self.importButton.delegate = self;
        self.importButton.hidden = YES;
    }
    
    [(DWUnapprovedPurchasesViewDataSource*)self.tableViewDataSource loadPurchases];
}

//----------------------------------------------------------------------------------------------------
- (UIView*)tableLoadingView {
    CGRect frame = self.view.frame;
    return [[DWUnapprovedPurchasesLoadingView alloc] initWithFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
}

//----------------------------------------------------------------------------------------------------
- (BOOL)testForPurchasesWiped {
    BOOL wiped = NO;
    
    DWUnapprovedPurchasesViewDataSource *dataSource = (DWUnapprovedPurchasesViewDataSource*)self.tableViewDataSource;
    
    if(dataSource.arePurchasesFinished &&
       dataSource.totalPurchases !=0 &&
       dataSource.rejectedIDs.count == dataSource.totalPurchases) {
        
        [self.spinner stopAnimating];
        self.importButton.hidden = YES;
        
        self.navigationItem.rightBarButtonItem = [DWGUIManager navBarDoneButtonWithTarget:self];
        
        wiped = YES;
    }
    
    return wiped;
}

//----------------------------------------------------------------------------------------------------
- (void)displayImportButton {
    [self.spinner stopAnimating];
    
    if(self.isUpdate)
        [self.importButton enterAddState];
    else
        [self.importButton enterCreateState];
    
    self.importButton.hidden = NO;
}

//----------------------------------------------------------------------------------------------------
- (void)applyStoreLogo:(DWStore*)store {
    if(!store.mediumImage)
        return;
    
    CGRect frame = self.storeLogo.frame;
    frame.size.width =  (frame.size.height / store.mediumImage.size.height) * store.mediumImage.size.width;
    frame.origin.x = 160 - frame.size.width / 2 + 10;
    
    
    self.storeLogo.frame = frame;
    self.storeLogo.image = store.mediumImage;
    self.storeLogo.hidden = NO;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UI Events

//----------------------------------------------------------------------------------------------------
- (void)doneButtonClicked {
    [self importButtonClicked];
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
- (void)unapprovedPurchasesStatus:(DWStore*)store
                         progress:(CGFloat)progress {
    if(store) {
        [store downloadMediumImage];
        [self applyStoreLogo:store];
    }
    
    [self.progressView updateDisplayWithTotalActive:1 totalFailed:0 totalProgress:progress];
}

//----------------------------------------------------------------------------------------------------
- (void)unapprovedPurchasesFinished:(NSInteger)count {
    
    self.storeLogo.hidden = YES;
    [self.progressView updateDisplayWithTotalActive:1 totalFailed:0 totalProgress:1.0];
    
    if(count) {
        if(![self testForPurchasesWiped])
            [self performSelector:@selector(displayImportButton) withObject:nil afterDelay:0.5];
    }
    else {
        [self.spinner stopAnimating];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                            message:@"Mine couldn't find any of your e-receipts at this time."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        alertView.tag = 0;
        [alertView show];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)unapprovedPurchasesApprovedWithCount:(NSInteger)count {
    
    if(count) {
        [self.delegate unapprovedPurchasesSuccessfullyApproved];
        
        [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Import Purchases Clicked"];
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
    [self displayImportButton];
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
    [self testForPurchasesWiped];
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
- (void)storeMediumImageLoaded:(NSNotification*)notification {
    NSDictionary *userInfo = [notification userInfo];
    
    DWStore *store = [DWStore fetch:[[userInfo objectForKey:kKeyResourceID] integerValue]];
    
    if(store)
        [self applyStoreLogo:store];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors

//----------------------------------------------------------------------------------------------------
- (void)willShowOnNav {
    [self.navigationController.navigationBar addSubview:self.progressView];
    [self.navigationController.navigationBar addSubview:self.spinner];
    [self.navigationController.navigationBar addSubview:self.storeLogo];
    [self.navigationController.navigationBar addSubview:self.importButton];
    
}

//----------------------------------------------------------------------------------------------------
- (void)requiresFullScreenMode {
    
}

@end
