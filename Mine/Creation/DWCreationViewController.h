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
    UITextField             *_searchTextField;
    UIView                  *_productPreview;
    UIView                  *_loadingView;
    UIImageView             *_productImageView;
    UIImageView             *_topShadowView;
    UIButton                *_productSelectButton;
    UIButton                *_productRejectButton;
    UIButton                *_cancelCreationButton;
    UIActivityIndicatorView *_spinner;
    
    __weak id<DWCreationViewControllerDelegate,NSObject> _delegate;
}

/**
 * IBOutlet properties
 */
@property (nonatomic) IBOutlet UITextField *searchTextField;
@property (nonatomic) IBOutlet UIView *productPreview;
@property (nonatomic) IBOutlet UIView *loadingView;
@property (nonatomic) IBOutlet UIImageView *productImageView;
@property (nonatomic) IBOutlet UIImageView *topShadowView;
@property (nonatomic) IBOutlet UIButton *productSelectButton;
@property (nonatomic) IBOutlet UIButton *productRejectButton;
@property (nonatomic) IBOutlet UIButton *cancelCreationButton;
@property (nonatomic) IBOutlet UIActivityIndicatorView *spinner;

/**
 * Delegate
 */
@property (nonatomic,weak) id<DWCreationViewControllerDelegate,NSObject> delegate;


/**
 * IBActions
 */
- (IBAction)productSelectButtonClicked:(id)sender;
- (IBAction)productRejectButtonClicked:(id)sender;
- (IBAction)cancelCreationButtonClicked:(id)sender;

@end


/**
 * Protocol for delegates of DWCreationViewController
 */
@protocol DWCreationViewControllerDelegate

@optional

/**
 * A product is selected from the search results
 */
- (void)productSelected:(DWProduct*)product 
              fromQuery:(NSString*)query;

/**
 * User cancels the creation process
 */
- (void)creationCancelled;

@end
