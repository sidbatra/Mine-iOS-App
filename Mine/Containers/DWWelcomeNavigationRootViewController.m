//
//  DWWelcomeNavigationRootViewController.m
//  Mine
//
//  Created by Siddharth Batra on 7/25/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWWelcomeNavigationRootViewController.h"
#import "DWConstants.h"

/**
 * Private declarations
 */
@interface DWWelcomeNavigationRootViewController ()

/**
 * End the welcome navigation by firing a notification.
 * It's supposed to be used when a user has successfully finished
 * either a log in or sign up and is now ready to enter the app.
 */
- (void)endWelcomeNavigationWithUser:(DWUser*)user;

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
- (void)endWelcomeNavigationWithUser:(DWUser*)user {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNWelcomeNavigationFinished
                                                        object:nil
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:user,kKeyUser,nil]];
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
    [self endWelcomeNavigationWithUser:user];
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
