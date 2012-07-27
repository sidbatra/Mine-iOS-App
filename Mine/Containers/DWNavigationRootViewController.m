//
//  DWNavigationRootViewController.m
//  Mine
//
//  Created by Siddharth Batra on 7/25/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWNavigationRootViewController.h"
#import "DWProfileViewController.h"

/**
 * Private declarations
 */
@interface DWNavigationRootViewController ()

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWNavigationRootViewController

//----------------------------------------------------------------------------------------------------
- (void)awakeFromNib {
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.delegate = self;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
}

//----------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav stack helpers

//----------------------------------------------------------------------------------------------------
- (void)displayUserProfile:(DWUser*)user {
    DWProfileViewController *profileViewController = [[DWProfileViewController alloc] initWithUser:user];
    
    [self.navigationController pushViewController:profileViewController
                                         animated:YES];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UINavigationControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)navigationController:(UINavigationController *)navigationController 
	  willShowViewController:(UIViewController *)viewController
					animated:(BOOL)animated {
    
    
	for (UIView *view in [self.navigationController.navigationBar subviews]) 
		if ([view respondsToSelector:@selector(shouldBeRemovedFromNav)]) 
            [view removeFromSuperview];
    
    
    if ([viewController respondsToSelector:@selector(willShowOnNav)])
        [viewController performSelector:@selector(willShowOnNav)];
    
    /*
    if ([viewController respondsToSelector:@selector(requiresFullScreenMode)])
        [self.customTabBarController enableFullScreen];
    else
        [self.customTabBarController disableFullScreen];
    
    
    if ([viewController respondsToSelector:@selector(hideTopShadowOnTabBar)])
        [self.customTabBarController hideTopShadowView];
    else
        [self.customTabBarController showTopShadowView];
     */
}


@end
