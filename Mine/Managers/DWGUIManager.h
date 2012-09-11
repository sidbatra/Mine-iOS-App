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
 * Custom done button used in the right side of the navigation bar
 */
+ (UIBarButtonItem*)navBarDoneButtonWithTarget:(id)target;

@end
