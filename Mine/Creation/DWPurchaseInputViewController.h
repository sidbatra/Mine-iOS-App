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
    UISwitch *_twitterSwitch;
}

/**
 * IBOutlet properties
 */
@property (nonatomic) IBOutlet UISwitch *twitterSwitch;


/**
 * Init with the product that was selected in the previous screen
 */
- (id)initWithProduct:(DWProduct*)product;

/**
 * IBActions
 */
- (IBAction)twitterSwitchToggled:(id)sender;

@end
