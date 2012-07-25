//
//  DWAppDelegate.h
//  Mine
//
//  Created by Siddharth Batra on 7/20/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DWTabBarController.h"

@interface DWAppDelegate : UIResponder <UIApplicationDelegate> {    
    DWTabBarController	*_tabBarController;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) DWTabBarController *tabBarController;

@end
