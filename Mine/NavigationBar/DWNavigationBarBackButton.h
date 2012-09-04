//
//  DWNavigationBarBackButton.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Custom back button for navigation controllers. It holds
 * a non retained reference to the navigation controller for
 * automatic popping
 */
@interface DWNavigationBarBackButton : UIView {
    __weak UINavigationController  *_navigationController;
}

/**
 * Non-retained reference to the navigation controller which will be
 * popped when the back button is clicked
 */
@property (nonatomic,weak) UINavigationController *navigationController;


/**
 * Helper method to create a bar button item out of the back button.
 */
+ (UIBarButtonItem*)backButtonForNavigationController:(UINavigationController*)navigationController;

@end
