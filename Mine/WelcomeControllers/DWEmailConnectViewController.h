//
//  DWEmailConnectViewController.h
//  Mine
//
//  Created by Siddharth Batra on 10/31/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DWEmailConnectViewControllerDelegate;


@interface DWEmailConnectViewController : UIViewController<UIWebViewDelegate> {
    UIButton    *_googleButton;
    UIButton    *_yahooButton;
    UIButton    *_hotmailButton;
    
    __weak id<DWEmailConnectViewControllerDelegate> _delegate;
}

@property (nonatomic,weak) id<DWEmailConnectViewControllerDelegate> delegate;


@property (nonatomic) IBOutlet UIButton *googleButton;
@property (nonatomic) IBOutlet UIButton *yahooButton;
@property (nonatomic) IBOutlet UIButton *hotmailButton;

- (IBAction)googleButtonClicked:(id)sender;
- (IBAction)yahooButtonClicked:(id)sender;
- (IBAction)hotmailButtonClicked:(id)sender;
- (IBAction)skipButtonClicked:(id)sender;

@end



@protocol DWEmailConnectViewControllerDelegate

@required

- (void)emailConnectGoogleAuthInitiated;
- (void)emailConnectYahooAuthInitiated;
- (void)emailConnectHotmailAuthInitiated;
- (void)emailConnectSkipped;

@end
