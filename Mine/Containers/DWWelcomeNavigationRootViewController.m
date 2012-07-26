//
//  DWWelcomeNavigationRootViewController.m
//  Mine
//
//  Created by Siddharth Batra on 7/25/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWWelcomeNavigationRootViewController.h"

/**
 * Private declarations
 */
@interface DWWelcomeNavigationRootViewController ()
@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWWelcomeNavigationRootViewController

@synthesize loginViewController = _loginViewController;

//----------------------------------------------------------------------------------------------------
- (void)awakeFromNib {
	[super awakeFromNib];	
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark View Lifecycle

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
    
    self.navigationController.navigationBarHidden           = YES;
    self.navigationController.navigationBar.clipsToBounds   = NO;
    
    if(!self.loginViewController) {
        self.loginViewController              = [[DWLoginViewController alloc] init];
        self.loginViewController.delegate     = self;
    }
    
    [self.view addSubview:self.loginViewController.view];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWLoginViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)userLoggedIn:(DWUser*)user {
    [user debug];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors

//----------------------------------------------------------------------------------------------------
- (void)willShowOnNav {
    [self.navigationController setNavigationBarHidden:YES 
                                             animated:NO];
}

@end
