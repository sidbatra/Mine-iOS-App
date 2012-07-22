//
//  DWTableViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DWTableViewDataSource.h"



/**
 * Model presenter hash key names
 */
extern NSString* const kModelKeyPresenter;
extern NSString* const kModelKeyPresenterStyle;
extern NSString* const kModelKeyIdentifier;




//#import "EGORefreshTableHeaderView.h"

/**
 * Customized version of UITableViewController which forms the base 
 * for every table view controller in the app
 */
@interface DWTableViewController : UITableViewController<DWTableViewDataSourceDelegate/*,EGORefreshTableHeaderDelegate*/> {
    
    DWTableViewDataSource       *_tableViewDataSource;
    
    NSMutableDictionary         *_modelPresenters;
    
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
 * Holds a mapping of the Presenter class, Presenter style and Identifier
 * for each 
 */
@property (nonatomic,strong) NSMutableDictionary *modelPresenters;

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

