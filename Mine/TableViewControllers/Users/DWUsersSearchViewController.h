//
//  DWUsersSearchViewController.h
//  Mine
//
//  Created by Siddharth Batra on 8/22/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWUsersViewController.h"

@protocol DWUsersSearchViewControllerDelegate;


@interface DWUsersSearchViewController : DWUsersViewController {
}

@property (nonatomic,weak) id<DWUsersSearchViewControllerDelegate,DWUsersViewControllerDelegate,NSObject> delegate;

/**
 * Clear the UI and start a new search.
 */
- (void)loadUsersForQuery:(NSString*)query;

/**
 * Reset the UI to the starting position.
 */
- (void)reset;

@end


@protocol DWUsersSearcViewControllerDelegate<DWUsersViewControllerDelegate>

@required

- (void)searchViewInviteFriendClicked;

@end