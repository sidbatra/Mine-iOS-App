//
//  DWGoogleAuthViewController.h
//  Mine
//
//  Created by Siddharth Batra on 10/31/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DWGoogleAuthViewControllerDelegate;


@interface DWGoogleAuthViewController : UIViewController {
    UIWebView *_webView;
    
    __weak id<DWGoogleAuthViewControllerDelegate> _delegate;
}

@property (nonatomic,weak) id<DWGoogleAuthViewControllerDelegate> delegate;

@property (nonatomic) IBOutlet UIWebView *webView;

@end


@protocol DWGoogleAuthViewControllerDelegate

@required

- (void)googleAuthAccepted;
- (void)googleAuthRejected;

@end