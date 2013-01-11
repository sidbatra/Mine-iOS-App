//
//  DWSuggestedUsersViewController.h
//  Mine
//
//  Created by Siddharth Batra on 1/2/13.
//  Copyright (c) 2013 Denwen, Inc. All rights reserved.
//

#import "DWUsersViewController.h"

@protocol DWSuggestedUsersViewControllerDelegate;


@interface DWSuggestedUsersViewController : DWUsersViewController {
    
}

@property (nonatomic,weak) id<DWSuggestedUsersViewControllerDelegate,DWUsersViewControllerDelegate,NSObject> delegate;

@end



@protocol DWSuggestedUsersViewControllerDelegate<DWUsersViewControllerDelegate>

@required

- (void)suggestedUsersInviteFriendClicked;

@end