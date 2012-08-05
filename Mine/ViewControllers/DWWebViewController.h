//
//  DWWebViewController.h
//  Mine
//
//  Created by Siddharth Batra on 8/5/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DWWebViewController : UIViewController {
    UIWebView   *_webView;
}

@property (nonatomic) IBOutlet UIWebView *webView;


/**
 * Init with URL to be displayed.
 */
- (id)initWithURL:(NSString*)url;

@end
