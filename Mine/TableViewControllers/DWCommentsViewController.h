//
//  DWCommentsViewController.h
//  Mine
//
//  Created by Siddharth Batra on 7/30/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWTableViewController.h"

@class DWUser;
@protocol DWCommentsViewControllerDelegate;


@interface DWCommentsViewController : DWTableViewController {
    __weak id<DWCommentsViewControllerDelegate> _delegate;
}

@property (nonatomic,weak) id<DWCommentsViewControllerDelegate> delegate;


- (id)initWithPurchaseID:(NSInteger)purchaseID
            loadRemotely:(BOOL)loadRemotely;

/**
 * Update UI after a new comment has been added.
 */
- (void)newCommentAdded;

/**
 * Update UI after a new comment failed to be created.
 */
- (void)newCommentFailed;

@end


@protocol DWCommentsViewControllerDelegate

@required

- (void)commentsViewUserClicked:(DWUser*)user;

@end
