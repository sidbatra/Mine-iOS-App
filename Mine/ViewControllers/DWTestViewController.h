//
//  DWTestViewController.h
//  Mine
//
//  Created by Siddharth Batra on 7/21/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DWUsersController.h"
#import "DWFeedController.h"

@interface DWTestViewController : UIViewController<DWUsersControllerDelegate,DWFeedControllerDelegate> {
    DWUsersController *_usersController;
    DWFeedController *_feedController;
}

@property (strong,nonatomic) DWUsersController *usersController;
@property (strong,nonatomic) DWFeedController *feedController;

@end
