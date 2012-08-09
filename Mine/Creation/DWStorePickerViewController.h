//
//  DWStorePickerViewController.h
//  Mine
//
//  Created by Deepak Rao on 8/9/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DWStoresViewController.h"

@protocol DWStorePickerViewControllerDelegate;
@class DWStore;

@interface DWStorePickerViewController : UIViewController<UITextFieldDelegate,DWStoresViewControllerDelegate> {
    UITextField *_searchTextField;

    __weak id<DWStorePickerViewControllerDelegate,NSObject> _delegate;
}

/**
 * IBOutlet properties
 */
@property (nonatomic) IBOutlet UITextField *searchTextField;

/**
 * IBActions
 */
- (IBAction)searchTextFieldEditingChanged:(id)sender;


/**
 * Delegate
 */
@property (nonatomic,weak) id<DWStorePickerViewControllerDelegate,NSObject> delegate;

@end


/**
 * Protocol for delegates of DWStorePickerViewController
 */
@protocol DWStorePickerViewControllerDelegate

@optional


@end
