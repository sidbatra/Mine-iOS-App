//
//  DWCreationViewController.h
//  Mine
//
//  Created by Deepak Rao on 8/3/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DWProductsViewController.h"

@protocol DWCreationViewControllerDelegate;
@class DWProduct;

@interface DWCreationViewController : UIViewController<UITextFieldDelegate,DWProductsViewControllerDelegate> {
    UITextField     *_searchTextField;
    UIView          *_productPreview;
    UIImageView     *_productImageView;
    UIButton        *_productSelectButton;
    UIButton        *_productRejectButton;    
    
    DWProduct       *_product;
    
    __weak id<DWCreationViewControllerDelegate,NSObject> _delegate;
}

/**
 * IBOutlet properties
 */
@property (nonatomic) IBOutlet UITextField *searchTextField;
@property (nonatomic) IBOutlet UIView *productPreview;
@property (nonatomic) IBOutlet UIImageView *productImageView;
@property (nonatomic) IBOutlet UIButton *productSelectButton;
@property (nonatomic) IBOutlet UIButton *productRejectButton;

/**
 * Product selected by the user
 */
@property (nonatomic,strong) DWProduct *product;

/**
 * Delegate
 */
@property (nonatomic,weak) id<DWCreationViewControllerDelegate,NSObject> delegate;


/**
 * IBActions
 */
- (IBAction)productSelectButtonClicked:(id)sender;
- (IBAction)productRejectButtonClicked:(id)sender;

@end


/**
 * Protocol for delegates of DWCreationViewController
 */
@protocol DWCreationViewControllerDelegate

@optional

/**
 * A product is selected from the search results
 */
- (void)productSelected:(DWProduct*)product;

@end