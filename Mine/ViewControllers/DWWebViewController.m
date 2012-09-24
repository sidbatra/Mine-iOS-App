//
//  DWWebViewController.m
//  Mine
//
//  Created by Siddharth Batra on 8/5/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWWebViewController.h"

#import "DWNavigationBarBackButton.h"
#import "DWToolbar.h"
#import "DWGUIManager.h"

static NSString* const kImgBack     = @"tab-web-back.png";
static NSString* const kImgForward  = @"tab-web-fwd.png";
static NSString* const kImgShare    = @"tab-web-share.png";
static NSString* const kLoadingText = @"Loading...";


@interface DWWebViewController () {
    NSURL *_url;
    BOOL    _viewLoaded;
    
    UIButton    *_backButton;
    UIButton    *_forwardButton;
}


@property (nonatomic,strong) NSURL *url;
@property (nonatomic,assign) BOOL viewLoaded;
@property (nonatomic,strong) UIButton *backButton;
@property (nonatomic,strong) UIButton *forwardButton;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWWebViewController

@synthesize webView         = _webView;
@synthesize toolbar         = _toolbar;
@synthesize url             = _url;
@synthesize viewLoaded      = _viewLoaded;
@synthesize backButton      = _backButton;
@synthesize forwardButton   = _forwardButton;

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
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    
    UIBarButtonItem *initialSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    initialSpacer.width = -12;
    
    if(!self.backButton) {
        self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,68,44)];
        self.backButton.enabled = NO;
        [self.backButton setBackgroundImage:[UIImage imageNamed:kImgBack] forState:UIControlStateNormal];
        
        [self.backButton addTarget:self
                   action:@selector(backButtonClicked)
         forControlEvents:UIControlEventTouchUpInside];
    }
        
    UIBarButtonItem *intraNavSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    intraNavSpacer.width = -10;
    
    if(!self.forwardButton) {
        self.forwardButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,68,44)];
        self.forwardButton.enabled = NO;
        [self.forwardButton setBackgroundImage:[UIImage imageNamed:kImgForward] forState:UIControlStateNormal];
        
        [self.forwardButton addTarget:self
                            action:@selector(forwardButtonClicked)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIBarButtonItem *postNavSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    postNavSpacer.width = 107;
    
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,68,44)];
    [shareButton setBackgroundImage:[UIImage imageNamed:kImgShare] forState:UIControlStateNormal];
    
    [shareButton addTarget:self
                           action:@selector(shareButtonClicked)
                 forControlEvents:UIControlEventTouchUpInside];
    
    
    self.toolbar.items = [NSArray arrayWithObjects:
                          initialSpacer,
                          [[UIBarButtonItem alloc] initWithCustomView:self.backButton], 
                          intraNavSpacer,
                          [[UIBarButtonItem alloc] initWithCustomView:self.forwardButton], 
                          postNavSpacer,
                          [[UIBarButtonItem alloc] initWithCustomView:shareButton], 
                          nil];
    
    
    [self displayTitle:kLoadingText];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
}

//----------------------------------------------------------------------------------------------------
- (void)displayTitle:(NSString*)title {
    self.navigationItem.titleView = [DWGUIManager navBarTitleViewWithText:title];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UIEvents

//----------------------------------------------------------------------------------------------------
- (void)backButtonClicked {
    [self.webView goBack];
}

//----------------------------------------------------------------------------------------------------
- (void)forwardButtonClicked {
    [self.webView goForward];
}

//----------------------------------------------------------------------------------------------------
- (void)shareButtonClicked {
    UIActionSheet *actionSheet  = [[UIActionSheet alloc] initWithTitle:nil 
                                                              delegate:self 
                                                     cancelButtonTitle:@"Cancel"
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:@"Open in Safari",nil];
    
    [actionSheet showInView:self.navigationController.view];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UIActionSheet Delegate

//----------------------------------------------------------------------------------------------------
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {	
    if(buttonIndex==0)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.webView.request.URL.absoluteString]];
}

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UIWebViewDelegate

//----------------------------------------------------------------------------------------------------
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    if(self.viewLoaded)
        [self displayTitle:kLoadingText];
}

//----------------------------------------------------------------------------------------------------
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    self.viewLoaded = YES;
    [self displayTitle:@"Error"];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

//----------------------------------------------------------------------------------------------------
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    self.viewLoaded = YES;
    [self displayTitle:[webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    self.backButton.enabled = webView.canGoBack;
    self.forwardButton.enabled = webView.canGoForward;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors

//----------------------------------------------------------------------------------------------------
- (void)willShowOnNav {
}

//----------------------------------------------------------------------------------------------------
- (void)requiresFullScreenMode {
    
}


@end
