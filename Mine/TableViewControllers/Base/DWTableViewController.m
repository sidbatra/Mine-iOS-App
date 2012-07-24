//
//  DWTableViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTableViewController.h"
#import "DWModelPresenter.h"
#import "DWLoadingView.h"
//#import "DWErrorView.h"
#import "NSObject+Helpers.h"


static NSString* const kModelKeyPresenter          = @"ModelKeyPresenter";
static NSString* const kModelKeyPresenterStyle     = @"ModelKeyPresenterStyle";
static NSString* const kModelKeyIdentifier         = @"ModelKeyIdentifier";


static NSString* const kPresenterClassSuffix        = @"Presenter";
static NSString* const kMsgNetworkError             = @"No connection; pull to retry.";


/**
 * Private method and property declarations
 */
@interface DWTableViewController() {
    NSMutableDictionary         *_modelPresenters;
    
    BOOL                        _isPullToRefreshActive;
    BOOL                        _disablePullToRefresh;
    
	EGORefreshTableHeaderView   *_refreshHeaderView;
}

/**
 * Holds a mapping of the Presenter class, Presenter style and Identifier
 * for each 
 */
@property (nonatomic,strong) NSMutableDictionary *modelPresenters;

/**
 * View for pull to refresh added above the table view
 */
@property (nonatomic,strong) EGORefreshTableHeaderView *refreshHeaderView;



/**
 * Pass the newly available resource to all visible cells to check
 * for possible UI updates
 */
- (void)provideResourceToVisibleCells:(NSInteger)resourceType
                             resource:(id)resource
                           resourceID:(NSInteger)resourceID;

/**
 * Enable scrolling & bouncing for the table view
 */
- (void)enableScrolling;

/**
 * Disable scrolling & bouncing for the table view
 */
- (void)disableScrolling;


@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTableViewController

@synthesize tableViewDataSource     = _tableViewDataSource;
@synthesize modelPresenters         = _modelPresenters;
@synthesize loadingView             = _loadingView;
@synthesize refreshHeaderView       = _refreshHeaderView;

/*
@synthesize errorView               = _errorView;
*/
 
//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if (self) {
        self.modelPresenters = [NSMutableDictionary dictionary];
    }
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    self.tableView  = nil;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
        
    CGRect frame		= self.view.frame;
	frame.origin.y		= 0; 
	self.view.frame		= frame;
    
    [self disableScrolling];

    self.tableView.backgroundColor  = [UIColor redColor];
	self.tableView.separatorStyle   = UITableViewCellSeparatorStyleNone;

    
    self.tableViewDataSource.delegate   = self;
    
    
    if(!self.refreshHeaderView && !_disablePullToRefresh) {
        self.refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 
                                                                                              0.0f - self.tableView.bounds.size.height,
                                                                                              self.view.frame.size.width,
                                                                                              self.tableView.bounds.size.height)];
        self.refreshHeaderView.delegate = self;
    }
    
    [self.tableView addSubview:self.refreshHeaderView];
    
    
    if(!self.loadingView)
        self.loadingView = [self tableLoadingView];
    
    [self.view addSubview:self.loadingView];
    
    
    /*
    if(!self.errorView) {
        self.errorView          = [self getTableErrorView];
        self.errorView.hidden   = YES;
    }
    
    [self.view addSubview:self.errorView];
     */
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
}

//----------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//----------------------------------------------------------------------------------------------------
- (void)scrollToTop {
    [self.tableView scrollRectToVisible:CGRectMake(0,0,1,1) 
                               animated:NO];
}

//----------------------------------------------------------------------------------------------------
- (void)disablePullToRefresh {
    _disablePullToRefresh = YES;
    
    [self.refreshHeaderView removeFromSuperview];
    self.refreshHeaderView = nil;
}

//----------------------------------------------------------------------------------------------------
- (void)addModelPresenterForClass:(Class)class 
                        withStyle:(NSInteger)style
                    withPresenter:(Class)presenter {
    
    [self.modelPresenters setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                     presenter,kModelKeyPresenter,
                                     [NSNumber numberWithInteger:style],kModelKeyPresenterStyle,
                                     @"DWPurchaseFeedCell_0", kModelKeyIdentifier, nil] forKey:[class className]];
}

//----------------------------------------------------------------------------------------------------
- (void)provideResourceToVisibleCells:(NSInteger)resourceType
                             resource:(id)resource
                           resourceID:(NSInteger)resourceID {
    
    if(![self isViewLoaded])
        return;
    
    NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];

	for (NSIndexPath *indexPath in visiblePaths) {            
        
        id object = [self.tableViewDataSource objectAtIndex:indexPath.row
                                                 forSection:indexPath.section];
        
        NSDictionary *presenter = [self presenterForModel:object];
        
        Class<DWModelPresenter> modelPresenter = [presenter objectForKey:kModelKeyPresenter];
        NSInteger modelPresenterStyle = [(NSNumber*)[presenter objectForKey:kModelKeyPresenterStyle] integerValue];
        
        id cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        [modelPresenter updatePresentationForCell:cell
                                         ofObject:object
                            withPresentationStyle:modelPresenterStyle
                                  withNewResource:resource
                                 havingResourceID:resourceID
                                           ofType:resourceType];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)enableScrolling {
    self.tableView.scrollEnabled    = YES;    
    self.tableView.bounces          = YES;
}

//----------------------------------------------------------------------------------------------------
- (void)disableScrolling {
    self.tableView.scrollEnabled    = NO;    
    self.tableView.bounces          = NO;
}

//----------------------------------------------------------------------------------------------------
- (UIView*)tableLoadingView {
    return [[DWLoadingView alloc] initWithFrame:self.view.frame];
}

/*
//----------------------------------------------------------------------------------------------------
- (UIView*)getTableErrorView {
    DWErrorView *errorView  = [[DWErrorView alloc] initWithFrame:self.tableView.frame];
    errorView.delegate      = self;
    
    return errorView;
}
 */

//----------------------------------------------------------------------------------------------------
- (NSDictionary*)presenterForModel:(id)object {
    return [self.modelPresenters objectForKey:[object className]];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UITableViewDataSource

//----------------------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.tableViewDataSource totalSections];
}

//----------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.tableViewDataSource totalObjectsForSection:section];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UITableViewDelegate

//----------------------------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    id object = [self.tableViewDataSource objectAtIndex:indexPath.row
                                             forSection:indexPath.section];
    
    NSDictionary *presenter = [self presenterForModel:object];

    Class<DWModelPresenter> modelPresenter = [presenter objectForKey:kModelKeyPresenter];
    NSInteger modelPresenterStyle = [(NSNumber*)[presenter objectForKey:kModelKeyPresenterStyle] integerValue];
    
    
	return [modelPresenter heightForObject:object
                     withPresentationStyle:modelPresenterStyle];
}

//----------------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id object = [self.tableViewDataSource objectAtIndex:indexPath.row
                                         forSection:indexPath.section];
    
    NSDictionary *presenter = [self presenterForModel:object];
    
    Class<DWModelPresenter> modelPresenter = [presenter objectForKey:kModelKeyPresenter];
    NSInteger modelPresenterStyle = [(NSNumber*)[presenter objectForKey:kModelKeyPresenterStyle] integerValue];
    NSString* modelIdentifier = [presenter objectForKey:kModelKeyIdentifier];
    
    id cell = [tableView dequeueReusableCellWithIdentifier:modelIdentifier];
    
	return [modelPresenter cellForObject:object
                            withBaseCell:cell
                      withCellIdentifier:modelIdentifier
                            withDelegate:self
                    andPresentationStyle:modelPresenterStyle];
}

//----------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        
    id object = [self.tableViewDataSource objectAtIndex:indexPath.row
                                         forSection:indexPath.section];
    
    NSDictionary *presenter = [self presenterForModel:object];

    Class<DWModelPresenter> modelPresenter = [presenter objectForKey:kModelKeyPresenter];
    NSInteger modelPresenterStyle = [(NSNumber*)[presenter objectForKey:kModelKeyPresenterStyle] integerValue];
    
    id cell = [self.tableView cellForRowAtIndexPath:indexPath];
    

    [modelPresenter cellClickedForObject:object
                            withBaseCell:cell
                   withPresentationStyle:modelPresenterStyle
                            withDelegate:self];
}



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UIScrollViewDelegate

//----------------------------------------------------------------------------------------------------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{		
	[self.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

//----------------------------------------------------------------------------------------------------
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	[self.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

//----------------------------------------------------------------------------------------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
}
 

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWTableViewDataSourceDelegate

//----------------------------------------------------------------------------------------------------
- (void)reloadTableView {
    [self enableScrolling];
    self.loadingView.hidden  = YES;
    //self.errorView.hidden           = YES;
    
    [self.tableView reloadData];

    [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    _isPullToRefreshActive          = NO;    
}

/*
//----------------------------------------------------------------------------------------------------
- (void)displayError:(NSString *)message 
       withRefreshUI:(BOOL)showRefreshUI {
    
    SEL sel = @selector(setErrorMessage:);
    
    if(![self.errorView respondsToSelector:sel])
        return;
    
    [self.errorView performSelector:sel
                         withObject:message];
    
    
    sel = showRefreshUI ? @selector(showRefreshUI) : @selector(hideRefreshUI);
    
    if(![self.errorView respondsToSelector:sel])
        return;
    
    [self.errorView performSelector:sel];
    

    
    [self scrollToTop];
    
    self.loadingView.hidden         = YES;
    self.errorView.hidden           = NO;
    
    [self disableScrolling];
    
    
    [self.tableView reloadData];
    
    _isPullToRefreshActive          = NO;
    [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

//----------------------------------------------------------------------------------------------------
- (void)displayError:(NSString *)message {
    
    [self displayError:message
         withRefreshUI:YES];
}
 */

//----------------------------------------------------------------------------------------------------
- (void)insertRowAtIndex:(NSInteger)index
           withAnimation:(UITableViewRowAnimation)animation {
    
    NSIndexPath *indexPath  = [NSIndexPath indexPathForRow:index
                                                     inSection:0];
    NSArray *indexPaths		= [NSArray arrayWithObjects:indexPath,nil];
    
    [self.tableView insertRowsAtIndexPaths:indexPaths
                          withRowAnimation:animation];
}

//----------------------------------------------------------------------------------------------------
- (void)removeRowAtIndex:(NSInteger)index 
           withAnimation:(UITableViewRowAnimation)animation {
    
    NSIndexPath *indexPath  = [NSIndexPath indexPathForRow:index
                                                 inSection:0];
    NSArray *indexPaths		= [NSArray arrayWithObjects:indexPath,nil];
    
    [self.tableView deleteRowsAtIndexPaths:indexPaths
                          withRowAnimation:animation];
}

//----------------------------------------------------------------------------------------------------
- (void)reloadRowAtIndex:(NSInteger)index {
    
    NSIndexPath *indexPath  = [NSIndexPath indexPathForRow:index
                                                 inSection:0];
    
    NSArray *indexPaths		= [NSArray arrayWithObjects:indexPath,nil];
    
    [self.tableView reloadRowsAtIndexPaths:indexPaths
                          withRowAnimation:UITableViewRowAnimationNone];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate 

//----------------------------------------------------------------------------------------------------
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view {
    _isPullToRefreshActive = YES;
    [self.tableViewDataSource refreshInitiated];
}

//----------------------------------------------------------------------------------------------------
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view {
	return _isPullToRefreshActive; 
}

//----------------------------------------------------------------------------------------------------
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view {
	return nil;
}

/*
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Error view delegate

//----------------------------------------------------------------------------------------------------
- (void)errorViewTouched {
    self.loadingView.hidden = NO;
    self.errorView.hidden   = YES;
    [self.tableViewDataSource refreshInitiated];
}
*/
@end
