//
//  DWTestViewController.h
//  Mine
//
//  Created by Siddharth Batra on 7/21/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DWUsersController.h"

@interface DWTestViewController : UIViewController<DWUsersControllerDelegate> {
    DWUsersController *_usersController;
}

@property (strong,nonatomic) DWUsersController *usersController;

@end
