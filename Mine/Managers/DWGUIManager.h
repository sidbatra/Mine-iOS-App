//
//  DWGUIManager.h
//  Mine
//
//  Created by Deepak Rao on 9/10/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

/**
 * Interface for generic GUI related factory and management methods
 */
@interface DWGUIManager : NSObject {
	
}

/**
 * Creates a UILabel to act as the title view for the navigation bar
 */
+ (UILabel*)navBarTitleViewWithText:(NSString*)text;

/**
 * Custom buttons used in the right side of the navigation bar
 */
+ (UIBarButtonItem*)navBarButtonWithTarget:(id)target
                                  selector:(SEL)selector
                                   onImage:(NSString*)onImage
                                  offImage:(NSString*)offImage;

+ (UIBarButtonItem*)navBarDoneButtonWithTarget:(id)target;

+ (UIBarButtonItem*)navBarSaveButtonWithTarget:(id)target;

+ (UIBarButtonItem*)navBarNextButtonWithTarget:(id)target;

+ (UIBarButtonItem*)navBarSendButtonWithTarget:(id)target;

+ (UIBarButtonItem*)navBarCloseButtonWithTarget:(id)target;

+ (UIBarButtonItem*)navBarCancelButtonWithTarget:(id)target;

/**
 * Fallback error view for handling connection/server errors
 */
+ (void)connectionErrorAlertView;
+ (void)connectionErrorAlertViewWithDelegate:(id)delegate;

@end
