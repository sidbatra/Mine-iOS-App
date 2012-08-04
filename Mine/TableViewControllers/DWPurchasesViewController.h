//
//  DWPurchasesViewController.h
//  Mine
//
//  Created by Siddharth Batra on 8/4/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWTableViewController.h"

#import "DWPurchaseFeedCell.h"
#import "DWLikesController.h"

@class DWUser;
@class DWPurchase;
@protocol DWPurchasesViewControllerDelegate;



@interface DWPurchasesViewController : DWTableViewController<DWPurchaseFeedCellDelegate,DWLikesControllerDelegate> {
    DWLikesController *_likesController;
    
    __weak id<DWPurchasesViewControllerDelegate,NSObject> _delegate;
}

/**
 * Data controller for the likes model.
 */
@property (nonatomic,strong) DWLikesController *likesController;


@property (nonatomic,weak) id<DWPurchasesViewControllerDelegate,NSObject> delegate;

@end



/**
 * Protocol for delegates of DWPurchasesViewController
 */
@protocol DWPurchasesViewControllerDelegate

@optional

/**
 * A user UI element is clicked from one of the feed cells.
 */
- (void)feedViewUserClicked:(DWUser*)user;

/**
 * An all likes button is clicked on a purchase.
 */
- (void)feedViewAllLikesClickedForPurchase:(DWPurchase*)purchase;

/**
 * A comment button is clicked to display comments fiew for a purchase.
 */
- (void)feedViewCommentClickedForPurchase:(DWPurchase*)purchase
                       withCreationIntent:(NSNumber*)creationIntent;

@end

