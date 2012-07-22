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
    
    NSMutableDictionary         *_modelPresentationStyle;
    
    /*
    BOOL                        _isPullToRefreshActive;
    
	EGORefreshTableHeaderView   *_refreshHeaderView;
    UIView                      *_loadingView;
    UIView                      *_errorView;
     */
}

/**
 * Custom overrideable datasource object for populating the table view.
 */
@property (nonatomic,strong) DWTableViewDataSource *tableViewDataSource;

/**
 * Holds a mapping of preesntation styles for the model objects that the table view
 * renders. It starts of empty, which means the default style for all models.
 */
@property (nonatomic,strong) NSMutableDictionary *modelPresentationStyle;

/**
 * View for pull to refresh added above the table view
 */
//@property (nonatomic) EGORefreshTableHeaderView *refreshHeaderView;

/**
 * View displayed when results are being fetched from the server
 */
//@property (nonatomic) UIView *loadingView;

/**
 * View displayed when an error occurs
 */
//@property (nonatomic) UIView *errorView;


/**
 * Scroll the table view to the top
 */
- (void)scrollToTop;

@end

