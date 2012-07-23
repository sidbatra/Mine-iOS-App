//
//  DWTableViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DWTableViewDataSource.h"



//#import "EGORefreshTableHeaderView.h"

/**
 * Customized version of UITableViewController which forms the base 
 * for every table view controller in the app
 */
@interface DWTableViewController : UITableViewController<DWTableViewDataSourceDelegate/*,EGORefreshTableHeaderDelegate*/> {
    
    DWTableViewDataSource       *_tableViewDataSource;
    
    UIView                      *_loadingView;
    /*
    BOOL                        _isPullToRefreshActive;
    
	EGORefreshTableHeaderView   *_refreshHeaderView;
    UIView                      *_errorView;
     */
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
 * View for pull to refresh added above the table view
 */
//@property (nonatomic) EGORefreshTableHeaderView *refreshHeaderView;

/**
 * View displayed when an error occurs
 */
//@property (nonatomic) UIView *errorView;


/**
 * Scroll the table view to the top
 */
- (void)scrollToTop;

/**
 * Add a model presenter mapping.
 */
- (void)addModelPresenterForClass:(Class)class 
                        withStyle:(NSInteger)style
                    withPresenter:(Class)presenter;



/**
 * Template method which can be overriden for custom laoding views which is a UIView 
 * displayed while the data is being loaded
 */
- (UIView*)tableLoadingView;

@end

