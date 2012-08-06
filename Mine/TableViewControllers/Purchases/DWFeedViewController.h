//
//  DWFeedViewController.h
//  Mine
//
//  Created by Siddharth Batra on 7/23/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWPurchasesViewController.h"


@protocol DWFeedViewControllerDelegate;


@interface DWFeedViewController : DWPurchasesViewController {
}

/**
 * Redefine the delegate
 */
@property (nonatomic,weak) id<DWPurchasesViewControllerDelegate,DWFeedViewControllerDelegate,NSObject> delegate;

@end


/**
 * Protocol for delegates of DWFeedViewController
 */
@protocol DWFeedViewControllerDelegate

@optional


@end
