//
//  DWWebViewController.m
//  Mine
//
//  Created by Siddharth Batra on 8/5/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWWebViewController.h"

#import "DWNavigationBarBackButton.h"
#import "DWNavigationBarTitleView.h"

@interface DWWebViewController () {
    NSURL *_url;
    DWNavigationBarTitleView *_navTitleView;
}

/**
 * URL to be displayed.
 */
@property (nonatomic,strong) NSURL *url;

@property (nonatomic,strong) DWNavigationBarTitleView *navTitleView;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWWebViewController

@synthesize webView         = _webView;
@synthesize url             = _url;
@synthesize navTitleView    = _navTitleView;

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
    
    self.navigationItem.leftBarButtonItem = [DWNavigationBarBackButton backButtonForNavigationController:self.navigationController];
    
    if(!self.navTitleView) 
        self.navTitleView = [DWNavigationBarTitleView logoTitleView];
    
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


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors

//----------------------------------------------------------------------------------------------------
- (void)willShowOnNav {
    [self.navigationController.navigationBar addSubview:self.navTitleView];
}

@end
