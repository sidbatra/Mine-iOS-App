//
//  DWCreationNavigationViewController.m
//  Mine
//
//  Created by Deepak Rao on 7/30/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWCreationNavigationViewController.h"
#import "DWCreationViewController.h"


/**
 * Private declarations
 */
@interface DWCreationNavigationViewController() {
    DWCreationViewController *_creationViewController;
}

/**
 * UIViewControllers for different creation screens
 */
@property (nonatomic,strong) DWCreationViewController *creationViewController;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWCreationNavigationViewController

@synthesize creationViewController = _creationViewController;

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
    
    self.navigationItem.title = @"Create";

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
- (void)productSelected:(DWProduct *)product {
    UIViewController *b = [[UIViewController alloc] init];
    [self.navigationController pushViewController:b animated:YES];
}

@end
