//
//  DWAppDelegate.h
//  Mine
//
//  Created by Siddharth Batra on 7/20/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DWTabBarController.h"
#import "DWUsersNavigationViewController.h"

/**
 * Custom app delegate
 */
@interface DWAppDelegate : UIResponder<UIApplicationDelegate,DWTabBarControllerDelegate,DWUsersNavigationViewControllerDelegate> {
    UINavigationController	*_welcomeNavController;
    UINavigationController  *_feedNavController;
    UINavigationController  *_profileNavController;
    UINavigationController  *_usersNavController;
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
@property (nonatomic) IBOutlet UINavigationController *profileNavController;
@property (nonatomic) IBOutlet UINavigationController *usersNavController;

@end
