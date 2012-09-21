//
//  DWEditBylineViewController.h
//  Mine
//
//  Created by Siddharth Batra on 9/20/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DWUsersController.h"

@interface DWEditBylineViewController : UIViewController<DWUsersControllerDelegate,UITextViewDelegate> {
    UITextView  *_bylineTextView;
    UIActivityIndicatorView *_spinnerView;
}

/**
 * IBOutlets
 */
@property (nonatomic) IBOutlet UITextView *bylineTextView;
@property (nonatomic) IBOutlet UIActivityIndicatorView *spinnerView;

@end
