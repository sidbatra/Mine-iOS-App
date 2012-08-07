//
//  DWPurchaseInputViewController.h
//  Mine
//
//  Created by Deepak Rao on 8/6/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DWProduct;

@interface DWPurchaseInputViewController : UIViewController {
    UISwitch    *_facebookSwitch;    
    UISwitch    *_twitterSwitch;
    UISwitch    *_tumblrSwitch;    
}

/**
 * IBOutlet properties
 */
@property (nonatomic) IBOutlet UISwitch *facebookSwitch;
@property (nonatomic) IBOutlet UISwitch *twitterSwitch;
@property (nonatomic) IBOutlet UISwitch *tumblrSwitch;


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
