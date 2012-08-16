//
//  DWCreationNavigationViewController.h
//  Mine
//
//  Created by Deepak Rao on 7/30/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWNavigationRootViewController.h"

@protocol DWCreationNavigationViewControllerDelegate;

@interface DWCreationNavigationViewController : DWNavigationRootViewController {
    __weak id<DWCreationNavigationViewControllerDelegate,NSObject> _delegate;
}

/**
 * Delegate
 */
@property (nonatomic,weak) id<DWCreationNavigationViewControllerDelegate,NSObject> delegate;

@end


/**
 * Protocol for delegates of DWCreationNavigationViewController
 */
@protocol DWCreationNavigationViewControllerDelegate

- (void)dismissCreateView;

@end