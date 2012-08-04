//
//  DWProfileViewController.h
//  Mine
//
//  Created by Siddharth Batra on 7/26/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWTableViewController.h"

@class DWUser;
@class DWPurchase;
@protocol DWProfileViewControllerDelegate;


@interface DWProfileViewController : DWTableViewController {
    DWUser  *_user;
    
    __weak id<DWProfileViewControllerDelegate,NSObject> delegate;
}

/**
 * The user whose profile is being displayed.
 */
@property (nonatomic,strong) DWUser *user;


/**
 * Delegate following the DWProfileViewControllerDelegate protocol.
 */
@property (nonatomic,weak) id<DWProfileViewControllerDelegate,NSObject> delegate;


/**
 * Init with the user whose profile is to be displayed.
 */ 
- (id)initWithUser:(DWUser*)user;

@end

/**
 * Delegate for DWProfileViewController
 */ 
@protocol DWProfileViewControllerDelegate

@optional

/**
 * A purchase element is clicked.
 */
- (void)profileViewPurchaseClicked:(DWPurchase*)purchase;

@end