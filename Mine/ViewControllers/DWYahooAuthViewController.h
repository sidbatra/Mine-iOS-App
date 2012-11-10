//
//  DWYahooAuthViewController.h
//  Mine
//
//  Created by Siddharth Batra on 11/1/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DWYahooAuthViewControllerDelegate;


@interface DWYahooAuthViewController : UIViewController {
    UIWebView *_webView;
    
    __weak id<DWYahooAuthViewControllerDelegate> _delegate;
}

@property (nonatomic,weak) id<DWYahooAuthViewControllerDelegate> delegate;

@property (nonatomic) IBOutlet UIWebView *webView;

@end


@protocol DWYahooAuthViewControllerDelegate

@required

- (void)yahooAuthAccepted;
- (void)yahooAuthRejected;

@end