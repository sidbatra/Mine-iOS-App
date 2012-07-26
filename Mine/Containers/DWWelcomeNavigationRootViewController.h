//
//  DWWelcomeNavigationRootViewController.h
//  Mine
//
//  Created by Siddharth Batra on 7/25/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWNavigationRootViewController.h"

#import "DWLoginViewController.h"

/**
 * Root view controller for the welcome navigation controller.
 */
@interface DWWelcomeNavigationRootViewController : DWNavigationRootViewController {
    DWLoginViewController   *_loginViewController;
}

@property (nonatomic,strong) DWLoginViewController *loginViewController;

@end
