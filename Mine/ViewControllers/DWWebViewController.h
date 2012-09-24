//
//  DWWebViewController.h
//  Mine
//
//  Created by Siddharth Batra on 8/5/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DWToolbar;

@interface DWWebViewController : UIViewController<UIWebViewDelegate,UIActionSheetDelegate> {
    UIWebView   *_webView;
    DWToolbar   *_toolbar;
}

@property (nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic) IBOutlet DWToolbar *toolbar;


/**
 * Init with URL to be displayed.
 */
- (id)initWithURL:(NSString*)url;

@end
