//
//  DWEmailConnectViewController.m
//  Mine
//
//  Created by Siddharth Batra on 10/31/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWEmailConnectViewController.h"
#import "DWNavigationBarBackButton.h"
#import "DWGUIManager.h"
#import "DWAnalyticsManager.h"

@interface DWEmailConnectViewController ()

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWEmailConnectViewController

@synthesize delegate = _delegate;
@synthesize googleButton = _googleButton;
@synthesize yahooButton = _yahooButton;
@synthesize hotmailButton = _hotmailButton;

//----------------------------------------------------------------------------------------------------
- (id)init {
    
    self = [super init];
    
    if (self) {
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
}

//----------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark View lifecycle

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem   = [DWNavigationBarBackButton backButtonForNavigationController:self.navigationController];
    self.navigationItem.titleView           = [DWGUIManager navBarTitleViewWithText:@"Start your Mine"];
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Welcome Connect"];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UI events

//----------------------------------------------------------------------------------------------------
- (IBAction)googleButtonClicked:(id)sender {
    [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Google Auth Initiated"];
    
    [self.delegate emailConnectGoogleAuthInitiated];
}

//----------------------------------------------------------------------------------------------------
- (IBAction)yahooButtonClicked:(id)sender {
    [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Yahoo Auth Initiated"];
    
    [self.delegate emailConnectYahooAuthInitiated];
}

//----------------------------------------------------------------------------------------------------
- (IBAction)hotmailButtonClicked:(id)sender {
    [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Hotmail Auth Initiated"];
    
    [self.delegate emailConnectHotmailAuthInitiated];
}

//----------------------------------------------------------------------------------------------------
- (IBAction)skipButtonClicked:(id)sender {
    [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Email Connect Skipped"];
    
    [self.delegate emailConnectSkipped];
}

@end
