//
//  DWAppDelegate.h
//  Mine
//
//  Created by Siddharth Batra on 7/20/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DWTabBarController.h"

/**
 * Custom app delegate
 */
@interface DWAppDelegate : UIResponder<UIApplicationDelegate,DWTabBarControllerDelegate> {    
}

/**
 * Window for the application
 */
@property (strong, nonatomic) IBOutlet UIWindow *window;

@end
