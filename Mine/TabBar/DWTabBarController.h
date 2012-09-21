//
//  DWTabBarController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DWTabBar.h"

@protocol DWTabBarControllerDelegate;


/**
 * Custom tab bar controller
 */
@interface DWTabBarController : UIViewController<DWTabBarDelegate> {
	DWTabBar    *_tabBar;
    	
	__weak id<DWTabBarControllerDelegate,NSObject> _delegate;
}

/**
 * Delegate receives updates about tab bar selection changes
 */
@property (nonatomic,weak) id<DWTabBarControllerDelegate,NSObject> delegate;

/**
 * Tab bar object for managing for the buttons and their states
 */
@property (nonatomic,strong) DWTabBar *tabBar;

/**
 * The currently selected controller on the tab bar.
 */
@property (nonatomic,readonly) UIViewController *selectedController;


/**
 * Add a sub controller that maps to a tab bar button.
 */
- (void)addSubController:(UIViewController*)controller;

/**
 * Enables full screen view for selected controller 
 */
- (void)enableFullScreen;

/**
 * Disables full screen for selected controller
 */
- (void)disableFullScreen;

/**
 * Highlight the tab at the given index
 */
//- (void)highlightTabAtIndex:(NSInteger)index;

/**
 * Dim the tab at the given index
 */
//- (void)dimTabAtIndex:(NSInteger)index;

/**
 * Hide the top show shadow image
 */
- (void)hideTopShadowView;

/**
 * Display the top shadow image
 */
- (void)showTopShadowView;

@end


/**
 * Delegate protocol to send events about index changes
 */
@protocol DWTabBarControllerDelegate

@optional

/**
 * Fired when the selected tab changes
 */
- (void)selectedTabModifiedFrom:(NSInteger)oldSelectedIndex 
							 to:(NSInteger)newSelectedIndex;
@end
