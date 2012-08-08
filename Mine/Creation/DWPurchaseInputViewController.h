//
//  DWPurchaseInputViewController.h
//  Mine
//
//  Created by Deepak Rao on 8/6/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DWPurchaseInputViewControllerDelegate;
@class DWProduct;
@class DWPurchase;

@interface DWPurchaseInputViewController : UIViewController<UITextFieldDelegate> {
    
    UITextField     *_nameTextField;
    UITextField     *_storeTextField;
    UITextField     *_reviewTextField;    
  
    UISwitch        *_facebookSwitch;    
    UISwitch        *_twitterSwitch;
    UISwitch        *_tumblrSwitch;    
    
    __weak id<DWPurchaseInputViewControllerDelegate,NSObject> _delegate;
}

/**
 * IBOutlet properties
 */
@property (nonatomic) IBOutlet UITextField *nameTextField;
@property (nonatomic) IBOutlet UITextField *storeTextField;
@property (nonatomic) IBOutlet UITextField *reviewTextField;

@property (nonatomic) IBOutlet UISwitch *facebookSwitch;
@property (nonatomic) IBOutlet UISwitch *twitterSwitch;
@property (nonatomic) IBOutlet UISwitch *tumblrSwitch;

/**
 * Delegate
 */
@property (nonatomic,weak) id<DWPurchaseInputViewControllerDelegate,NSObject> delegate;

/**
 * Init with the product that was selected in the previous screen
 */
- (id)initWithProduct:(DWProduct*)product;

/**
 * IBActions
 */
- (IBAction)facebookSwitchToggled:(id)sender;
- (IBAction)twitterSwitchToggled:(id)sender;
- (IBAction)tumblrSwitchToggled:(id)sender;

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