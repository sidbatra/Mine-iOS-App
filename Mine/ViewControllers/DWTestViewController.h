//
//  DWTestViewController.h
//  Mine
//
//  Created by Siddharth Batra on 7/21/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DWUsersController.h"
#import "DWFeedViewController.h"
#import "DWFeedController.h"
#import "DWFacebookConnect.h"

@interface DWTestViewController : UIViewController<DWUsersControllerDelegate,DWFeedControllerDelegate,DWFacebookConnectDelegate> {
    DWUsersController *_usersController;
    DWFeedController *_feedController;
    DWFacebookConnect *_facebookConnect;
    DWFeedViewController *_feedViewController;

}

@property (strong,nonatomic) DWUsersController *usersController;
@property (strong,nonatomic) DWFeedController *feedController;
@property (strong,nonatomic) DWFacebookConnect *facebookConnect;
@property (nonatomic,strong) DWFeedViewController *feedViewController;


@end
