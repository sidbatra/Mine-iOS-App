//
//  DWCommentsCreateViewController.h
//  Mine
//
//  Created by Siddharth Batra on 7/30/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DWCommentsViewController.h"
#import "DWCommentsController.h"

@class DWUser;
@class DWPurchase;
@protocol DWCommentsCreateViewControllerDelegate;


@interface DWCommentsCreateViewController : UIViewController<UITextFieldDelegate,DWCommentsViewControllerDelegate,DWCommentsControllerDelegate> {
    UIImageView     *_commentBarView;
    UITextField     *_commentTextField;
    UIButton        *_sendButton;
    
    __weak id<DWCommentsCreateViewControllerDelegate> _delegate;
}

@property (nonatomic,weak) id<DWCommentsCreateViewControllerDelegate> delegate;


@property (nonatomic) IBOutlet UIImageView *commentBarView;
@property (nonatomic) IBOutlet UITextField *commentTextField;
@property (nonatomic) IBOutlet UIButton *sendButton;


/**
 * Init with purchase whose comments are being displayed & created.
 */
- (id)initWithPurchase:(DWPurchase*)purchase 
    withCreationIntent:(BOOL)creationIntent;

- (IBAction)sendButtonClicked:(id)sender;

@end



@protocol DWCommentsCreateViewControllerDelegate

@required

- (void)commentsCreateViewUserClicked:(DWUser*)user;

@end
