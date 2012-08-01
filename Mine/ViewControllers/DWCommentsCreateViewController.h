//
//  DWCommentsCreateViewController.h
//  Mine
//
//  Created by Siddharth Batra on 7/30/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DWCommentsController.h"

@class DWPurchase;

@interface DWCommentsCreateViewController : UIViewController<UITextFieldDelegate,DWCommentsControllerDelegate> {
    UITextField     *_commentTextField;
}

/**
 * Text field for creating comments.
 */
@property (nonatomic) IBOutlet UITextField *commentTextField;


/**
 * Init with purchase whose comments are being displayed & created.
 */
- (id)initWithPurchase:(DWPurchase*)purchase 
    withCreationIntent:(BOOL)creationIntent;

@end