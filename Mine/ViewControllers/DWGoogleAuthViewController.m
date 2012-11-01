//
//  DWGoogleAuthViewController.m
//  Mine
//
//  Created by Siddharth Batra on 10/31/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWGoogleAuthViewController.h"
#import "DWRequestManager.h"
#import "DWConstants.h"

static NSString* const kGoogleAuthURI       = @"/auth/google?web_view_mode=true";
static NSString* const kGoogleApprovedURI   = @"/approved";
static NSString* const kGoogleRejectedURI   = @"/rejected";



@interface DWGoogleAuthViewController ()

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWGoogleAuthViewController

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
    
    NSURL *url = [NSURL URLWithString:[[DWRequestManager sharedDWRequestManager] createAppRequestURL:kGoogleAuthURI
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
         
        if ([path isEqual:kGoogleApprovedURI]) {
            [self.delegate googleAuthAccepted];
        }
        else if([path isEqualToString:kGoogleRejectedURI]) {
            [self.delegate googleAuthRejected];
        }
         
        return NO;
    }
    
    return YES;
}

@end
