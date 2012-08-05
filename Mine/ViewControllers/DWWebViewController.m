//
//  DWWebViewController.m
//  Mine
//
//  Created by Siddharth Batra on 8/5/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWWebViewController.h"

@interface DWWebViewController () {
    NSURL *_url;
}

/**
 * URL to be displayed.
 */
@property (nonatomic,strong) NSURL *url;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWWebViewController

@synthesize webView = _webView;
@synthesize url     = _url;

//----------------------------------------------------------------------------------------------------
- (id)initWithURL:(NSString*)url {
    self = [super init];
    
    if (self) {
        self.url = [NSURL URLWithString:url];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UIWebViewDelegate


//----------------------------------------------------------------------------------------------------
- (void)webViewDidStartLoad:(UIWebView *)webView {
}

//----------------------------------------------------------------------------------------------------
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

//----------------------------------------------------------------------------------------------------
-(void)webViewDidFinishLoad:(UIWebView *)webView{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


@end
