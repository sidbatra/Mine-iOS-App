//
//  DWEmailConnectViewController.m
//  Mine
//
//  Created by Siddharth Batra on 10/31/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWEmailConnectViewController.h"

@interface DWEmailConnectViewController ()

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWEmailConnectViewController

@synthesize delegate = _delegate;
@synthesize googleButton = _googleButton;
@synthesize yahooButton = _yahooButton;

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
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UI events

//----------------------------------------------------------------------------------------------------
- (IBAction)googleButtonClicked:(id)sender {
    [self.delegate emailConnectGoogleAuthInitiated];
}

//----------------------------------------------------------------------------------------------------
- (IBAction)yahooButtonClicked:(id)sender {
    [self.delegate emailConnectYahooAuthInitiated];
}

@end
