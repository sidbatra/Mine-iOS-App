//
//  DWFeedViewController.h
//  Mine
//
//  Created by Siddharth Batra on 7/23/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWTableViewController.h"

#import "DWLikesController.h"
#import "DWPurchaseFeedCell.h"

@class DWUser;
@protocol DWFeedViewControllerDelegate;


@interface DWFeedViewController : DWTableViewController<DWPurchaseFeedCellDelegate,DWLikesControllerDelegate> {
    DWLikesController *_likesController;
    
    __weak id<DWFeedViewControllerDelegate,NSObject> _delegate;
}

/**
 * Data controller for the likes model.
 */
@property (nonatomic,strong) DWLikesController *likesController;

/**
 * Delegate
 */
@property (nonatomic,weak) id<DWFeedViewControllerDelegate,NSObject> delegate;

@end


/**
 * Protocol for delegates of DWFeedViewController
 */
@protocol DWFeedViewControllerDelegate

@optional

/**
 * A user UI element is clicked from one of the feed cells.
 */
- (void)feedViewUserClicked:(DWUser*)user;

@end
