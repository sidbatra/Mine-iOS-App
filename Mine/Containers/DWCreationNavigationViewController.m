//
//  DWCreationNavigationViewController.m
//  Mine
//
//  Created by Deepak Rao on 7/30/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWCreationNavigationViewController.h"
#import "DWNavigationBar.h"
#import "DWAnalyticsManager.h"
#import "DWConstants.h"

/**
 * Private declarations
 */
@interface DWCreationNavigationViewController() {    
    DWCreationViewController        *_creationViewController;
}

/**
 * UIViewController for the first creation screen
 */
@property (nonatomic,strong) DWCreationViewController *creationViewController;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWCreationNavigationViewController

@synthesize creationViewController          = _creationViewController;
@synthesize delegate                        = _delegate;

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
    
    [self.navigationController setValue:[[DWNavigationBar alloc] init] forKeyPath:@"navigationBar"];
    self.navigationController.navigationBarHidden = YES;

    if(!self.creationViewController) {
        self.creationViewController = [[DWCreationViewController alloc] init];
        self.creationViewController.delegate = self;
    }
    
    [self.view addSubview:self.creationViewController.view];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWCreationViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)creationCancelled {
    [self.delegate dismissCreateView];
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Creation Cancelled"];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWPurchaseInputViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)postPurchase:(DWPurchase *)purchase 
             product:(DWProduct *)product 
           shareToFB:(BOOL)shareToFB 
           shareToTW:(BOOL)shareToTW 
           shareToTB:(BOOL)shareToTB {
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNRequestTabBarIndexChange
                                                        object:nil
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                [NSNumber numberWithInteger:kFeedTabIndex],kKeyTabIndex,
                                                                [NSNumber numberWithInteger:DWTabBarResetTypeHard],kKeyResetType,
                                                                nil]];
    
    [super postPurchase:purchase 
                product:product 
              shareToFB:shareToFB 
              shareToTW:shareToTW 
              shareToTB:shareToTB];

    [self.delegate dismissCreateView];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors

//----------------------------------------------------------------------------------------------------
- (void)willShowOnNav {
    
     if(!self.navigationController.navigationBarHidden)
         [self.navigationController setNavigationBarHidden:YES
                                                  animated:YES];
         
}

@end
