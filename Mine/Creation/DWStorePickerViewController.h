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
    UITextField     *_searchTextField;
    UIButton        *_doneButton;

    __weak id<DWStorePickerViewControllerDelegate,NSObject> _delegate;
}

/**
 * IBOutlet properties
 */
@property (nonatomic) IBOutlet UITextField *searchTextField;
@property (nonatomic) IBOutlet UIButton *doneButton;

/**
 * Delegate
 */
@property (nonatomic,weak) id<DWStorePickerViewControllerDelegate,NSObject> delegate;


/**
 * IBActions
 */
- (IBAction)searchTextFieldEditingChanged:(id)sender;
- (IBAction)doneButtonClicked:(id)sender;


/**
 * Start loading stores before the picker opens.
 */
- (void)preloadStores;

@end


/**
 * Protocol for delegates of DWStorePickerViewController
 */
@protocol DWStorePickerViewControllerDelegate

/**
 * Fired when a store is picked
 */
- (void)storePicked:(NSString*)storeName;

@end
