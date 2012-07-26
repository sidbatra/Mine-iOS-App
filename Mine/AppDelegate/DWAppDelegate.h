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
    UINavigationController	*_welcomeNavController;
    UINavigationController  *_feedNavController;
}

/**
 * Window for the application
 */
@property (nonatomic) IBOutlet UIWindow *window;

/**
 * IBOutlets
 */
@property (nonatomic) IBOutlet UINavigationController *welcomeNavController;
@property (nonatomic) IBOutlet UINavigationController *feedNavController;

@end
