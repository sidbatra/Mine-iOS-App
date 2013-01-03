//
//  DWUsersNavigationViewController.h
//  Mine
//
//  Created by Siddharth Batra on 1/2/13.
//  Copyright (c) 2013 Denwen, Inc. All rights reserved.
//

#import "DWNavigationRootViewController.h"
#import "DWUsersSearchViewController.h"
#import "DWSuggestedUsersViewController.h"

#import "DWSearchBar.h"

@protocol DWUsersNavigationViewControllerDelegate;

@interface DWUsersNavigationViewController : DWNavigationRootViewController<DWUsersSearcViewControllerDelegate,DWSearchBarDelegate> {
    __weak id<DWUsersNavigationViewControllerDelegate> _delegate;
}

@property (nonatomic,weak) id<DWUsersNavigationViewControllerDelegate> delegate;

@end


@protocol DWUsersNavigationViewControllerDelegate

@required

- (void)usersNavViewDismiss;

@end