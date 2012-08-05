//
//  DWNavigationRootViewController.m
//  Mine
//
//  Created by Siddharth Batra on 7/25/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWNavigationRootViewController.h"
#import "DWCommentsCreateViewController.h"
#import "DWLikersViewController.h"
#import "DWPurchaseViewController.h"

#import "DWPurchase.h"

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
    profileViewController.delegate = self;
    
    [self.navigationController pushViewController:profileViewController
                                         animated:YES];
}

//----------------------------------------------------------------------------------------------------
- (void)displayAllLikesForPurchase:(DWPurchase*)purchase {
    DWLikersViewController *likersViewController = [[DWLikersViewController alloc] initWithPurhcase:purchase];
    likersViewController.delegate = self;
    
    [self.navigationController pushViewController:likersViewController
                                         animated:YES];
}

//----------------------------------------------------------------------------------------------------
- (void)displayCommentsCreateViewForPurchase:(DWPurchase*)purchase 
                          withCreationIntent:(BOOL)creationIntent {
    
    DWCommentsCreateViewController *commentsViewController = [[DWCommentsCreateViewController alloc] initWithPurchase:purchase
                                                                                                   withCreationIntent:creationIntent];
    
    [self.navigationController pushViewController:commentsViewController 
                                         animated:YES];
}

//----------------------------------------------------------------------------------------------------
- (void)displayPurchaseViewForPurchase:(DWPurchase*)purchase {
    
    DWPurchaseViewController *purchaseViewController = [[DWPurchaseViewController alloc] initWithPurhcase:purchase];
    purchaseViewController.delegate = self;
    
    [self.navigationController pushViewController:purchaseViewController 
                                         animated:YES];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWProfileViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)profileViewPurchaseClicked:(DWPurchase *)purchase {
    [self displayPurchaseViewForPurchase:purchase];
}

//----------------------------------------------------------------------------------------------------
- (void)profileViewPurchaseURLClicked:(DWPurchase *)purchase {
    NSLog(@"profile url clicked - %@",purchase.sourceURL);
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWUsersViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)usersViewUserClicked:(DWUser *)user {
    [self displayUserProfile:user];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWPurchasesViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)purchasesViewUserClicked:(DWUser *)user {
    [self displayUserProfile:user];
}

//----------------------------------------------------------------------------------------------------
- (void)purchasesViewAllLikesClickedForPurchase:(DWPurchase *)purchase {
    [self displayAllLikesForPurchase:purchase];
}

//----------------------------------------------------------------------------------------------------
- (void)purchasesViewCommentClickedForPurchase:(DWPurchase *)purchase 
                            withCreationIntent:(NSNumber *)creationIntent {
    
    [self displayCommentsCreateViewForPurchase:purchase
                            withCreationIntent:[creationIntent boolValue]];
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
