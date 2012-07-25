//
//  DWTableViewDataSource.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol DWTableViewDataSourceDelegate;


/**
 * Data source for the DWTableViewController implementation.
 * Its child classes are responsible for storing and procuring
 * data for table view across the application.
 */
@interface DWTableViewDataSource : NSObject {
    NSMutableArray  *_objects;
    
    __weak id<DWTableViewDataSourceDelegate,NSObject> _delegate;
}

/**
 * Holds objects that correspond to the rows of a table view controller
 */
@property (nonatomic,strong) NSMutableArray *objects;

/**
 * Delegate for communicating with the table view controller
 */
@property (nonatomic,weak) id<DWTableViewDataSourceDelegate,NSObject> delegate;


/**
 * Get the total number of sections 
 */
- (NSInteger)totalSections;

/**
 * Fetch the total number of objects for the given section
 */
- (NSInteger)totalObjectsForSection:(NSInteger)section;

/**
 * Fetch the object at the given index
 */
- (id)objectAtIndex:(NSInteger)index 
         forSection:(NSInteger)section;

/**
 * Fired when a user generated or automated refresh is initiated
 */
- (void)refreshInitiated;

@end



/**
 * DWTableViewDataSource delegate definition. It's used to communicate
 * with the table view controller for which its a data source
 */
@protocol DWTableViewDataSourceDelegate

/**
 * Request a full reload
 */
- (void)reloadTableView;

/**
 * Inserts a new row into the table view
 * with specified animation
 */
- (void)insertRowAtIndex:(NSInteger)index
           withAnimation:(UITableViewRowAnimation)animation;

/**
 * Removes an existing row from the table view
 * with specified animation
 */
- (void)removeRowAtIndex:(NSInteger)index 
           withAnimation:(UITableViewRowAnimation)animation;

/**
 * Reload the cell at the given index
 */
- (void)reloadRowAtIndex:(NSInteger)index;

/**
 * Display an error message with an option for display a retry 
 * / refresh UI.
 */
- (void)displayError:(NSString *)message 
       withRefreshUI:(BOOL)showRefreshUI;

@end


