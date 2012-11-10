//
//  DWTableViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DWTableViewDataSource.h"

#import "DWErrorView.h"
#import "DWErrorViewProtocol.h"

#import "EGORefreshTableHeaderView.h"


/**
 * Customized version of UITableViewController which forms the base 
 * for every table view controller in the app
 */
@interface DWTableViewController : UITableViewController<DWTableViewDataSourceDelegate,EGORefreshTableHeaderDelegate,DWErrorViewDelegate> {
    
    DWTableViewDataSource       *_tableViewDataSource;
    
    UIView                      *_loadingView;
    UIView<DWErrorViewProtocol> *_errorView;
}

/**
 * Custom overrideable datasource object for populating the table view.
 */
@property (nonatomic,strong) DWTableViewDataSource *tableViewDataSource;

/**
 * View displayed when results are being fetched from the server
 */
@property (nonatomic,strong) UIView *loadingView;

/**
 * View displayed when an error occurs
 */
@property (nonatomic,strong) UIView<DWErrorViewProtocol> *errorView;


/**
 * Forces the data source to initiate a refresh
 */
- (void)forceRefresh;

/**
 * Scroll the table view to the top
 */
- (void)scrollToTop;

/**
 * Scroll the table view to the bottom.
 */
- (void)scrollToBottomWithAnimation:(BOOL)animated;

/**
 * Method to disable pull to refresh for certain table views
 */
- (void)disablePullToRefresh;

/**
 * Returns if the table view is in a normal state and is displaying cells
 */
- (BOOL)isDisplayingCells;

/**
 * Add a model presenter mapping.
 */
- (void)addModelPresenterForClass:(Class)class 
                        withStyle:(NSInteger)style
                    withPresenter:(Class)presenter;

/**
 * Pass the newly available resource to all visible cells to check
 * for possible UI updates
 */
- (void)provideResourceToVisibleCells:(Class)objectClass
                             objectID:(NSInteger)objectID
                            objectKey:(NSString*)objectKey;

/**
 * Template method which can be overriden for custom laoding views which is a UIView 
 * displayed while the data is being loaded
 */
- (UIView*)tableLoadingView;

/**
 * Template method which can be overriden for custom error views which is a UIView 
 * displayed on error and follows the DWErrorViewProtocol.
 */
- (UIView<DWErrorViewProtocol>*)tableErrorView;

/**
 * Adjust Y positioning of the supporting views.
 */
- (void)adjustSupportingViewsY:(CGFloat)delta;

@end

