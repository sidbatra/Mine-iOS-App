//
//  DWLoginViewController.h
//  Mine
//
//  Created by Siddharth Batra on 7/25/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Displays view for logging in existing users.
 */
@interface DWLoginViewController : UIViewController {
    UIButton *_loginWithFBButton;
}

/**
 * IBOutlets
 */
@property (nonatomic) IBOutlet UIButton *loginWithFBButton;


/**
 * IBActions
 */
 - (IBAction)loginWithFBButtonClicked:(id)sender;

@end
