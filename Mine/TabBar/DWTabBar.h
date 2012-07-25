//
//  DWTabBar.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DWTabBarDelegate;

/**
 * Custom tab bar
 */
@interface DWTabBar : UIView {
	NSInteger		_selectedIndex;
	
	__weak id<DWTabBarDelegate> _delegate;
}

/**
 * Currently selected tab bar button
 */
@property (nonatomic,readonly) NSInteger selectedIndex;

/**
 * Delegate receives updates about changes in tab selection
 */
@property (nonatomic,weak) id<DWTabBarDelegate> delegate;


/**
 * Highlights the tab at the given index
 */
//- (void)highlightTabAtIndex:(NSInteger)index;

/**
 * Dims the tab at the given index
 */
//- (void)dimTabAtIndex:(NSInteger)index;

/**
 * Add a new tab onto the bar.
 */
- (void)addTabWithWidth:(NSInteger)width 
        normalImageName:(NSString*)normalImageName
      selectedImageName:(NSString*)selectImageName 
   highlightedImageName:(NSString*)highlightedImageName
   isMappedToController:(BOOL)controllerMapping
             isSelected:(BOOL)isSelected;

@end


/**
 * Delegate protocol for the custom tab bar
 */
@protocol DWTabBarDelegate

/**
 * Fired when current tab changes.
 * navReset - Pops the selected nav to root view controller
 */
- (void)selectedTabWithSpecialTab:(BOOL)isSpecial
					 modifiedFrom:(NSInteger)oldSelectedIndex 
							   to:(NSInteger)newSelectedIndex
                    withResetType:(NSInteger)resetType;
@end