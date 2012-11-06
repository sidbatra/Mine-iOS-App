//
//  DWYahooAuthViewController.m
//  Mine
//
//  Created by Siddharth Batra on 11/1/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWYahooAuthViewController.h"
#import "DWRequestManager.h"
#import "DWNavigationBarBackButton.h"
#import "DWAnalyticsManager.h"
#import "DWConstants.h"

static NSString* const kYahooAuthURI       = @"/auth/yahoo?web_view_mode=true";
static NSString* const kYahooApprovedURI   = @"/approved";
static NSString* const kYahooRejectedURI   = @"/rejected";



@interface DWYahooAuthViewController ()

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWYahooAuthViewController

@synthesize webView = _webView;
@synthesize delegate = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    
    self = [super init];
    
    if (self) {
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [DWNavigationBarBackButton backButtonForNavigationController:self.navigationController];
    
    NSURL *url = [NSURL URLWithString:[[DWRequestManager sharedDWRequestManager] createAppRequestURL:kYahooAuthURI
                                                                                        authenticate:YES]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UIWebViewDelegate

//----------------------------------------------------------------------------------------------------
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if ([[request.URL scheme] isEqual:kInternalAppScheme]) {
        
        NSString *path = [request.URL path];
        
        if ([path isEqual:kYahooApprovedURI]) {
            [self.delegate yahooAuthAccepted];
            
            [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Yahoo Auth Accepted"];
        }
        else if([path isEqualToString:kYahooRejectedURI]) {
            [self.delegate yahooAuthRejected];
            
            [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Yahoo Auth Rejected"];
        }
        
        return NO;
    }
    
    return YES;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav stack selectors

//----------------------------------------------------------------------------------------------------
- (void)requiresFullScreenMode {
}

@end
