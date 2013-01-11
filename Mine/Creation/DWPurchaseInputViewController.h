//
//  DWPurchaseInputViewController.h
//  Mine
//
//  Created by Deepak Rao on 8/6/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DWStorePickerViewController.h"
#import "DWFacebookConnectViewController.h"
#import "DWTwitterIOSConnect.h"
#import "DWTwitterConnectViewController.h"
#import "DWTumblrConnectViewController.h"

@protocol DWPurchaseInputViewControllerDelegate;
@class DWProduct;
@class DWPurchase;

@interface DWPurchaseInputViewController : UIViewController<UITextFieldDelegate,DWStorePickerViewControllerDelegate,DWFacebookConnectViewControllerDelegate,DWTwitterIOSConnectDelegate,DWTwitterConnectViewControllerDelegate,DWTumblrConnectViewControllerDelegate> {
    
    UITextField     *_nameTextField;
    UITextField     *_reviewTextField; 
    
    UILabel         *_storeNameLabel;
    UIButton        *_storePickerButton;
  
    UIButton        *_facebookConfigureButton;
    UIButton        *_twitterConfigureButton;
    UIButton        *_tumblrConfigureButton;
    
    UISwitch        *_facebookSwitch;    
    UISwitch        *_twitterSwitch;
    UISwitch        *_tumblrSwitch;    
    
    __weak id<DWPurchaseInputViewControllerDelegate,NSObject> _delegate;
}

/**
 * IBOutlet properties
 */
@property (nonatomic) IBOutlet UITextField *nameTextField;
@property (nonatomic) IBOutlet UITextField *reviewTextField;
@property (nonatomic) IBOutlet UILabel *storeNameLabel;
@property (nonatomic) IBOutlet UIButton *storePickerButton;

@property (nonatomic) IBOutlet UIButton *facebookConfigureButton;
@property (nonatomic) IBOutlet UIButton *twitterConfigureButton;
@property (nonatomic) IBOutlet UIButton *tumblrConfigureButton;

@property (nonatomic) IBOutlet UISwitch *facebookSwitch;
@property (nonatomic) IBOutlet UISwitch *twitterSwitch;
@property (nonatomic) IBOutlet UISwitch *tumblrSwitch;

/**
 * Delegate
 */
@property (nonatomic,weak) id<DWPurchaseInputViewControllerDelegate,NSObject> delegate;

/**
 * Initialize with a partial purchase and the selected product from the previous screen
 */
- (id)initWithProduct:(DWProduct*)product 
          andPurchase:(DWPurchase*)purchase;

/**
 * IBActions
 */
- (IBAction)storePickerButtonClicked:(id)sender;
- (IBAction)facebookConfigureButtonClicked:(id)sender;
- (IBAction)twitterConfigureButtonClicked:(id)sender;
- (IBAction)tumblrConfigureButtonClicked:(id)sender;

@end



/**
 * Protocol for delegates of DWPurchaseInputViewController
 */
@protocol DWPurchaseInputViewControllerDelegate

- (void)postPurchase:(DWPurchase*)purchase 
             product:(DWProduct*)product 
           shareToFB:(BOOL)shareToFB 
           shareToTW:(BOOL)shareToTW 
           shareToTB:(BOOL)shareToTB;

@end