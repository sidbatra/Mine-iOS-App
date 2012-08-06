//
//  DWProfileNavigationViewController.m
//  Mine
//
//  Created by Siddharth Batra on 7/26/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWProfileNavigationViewController.h"

#import "DWProfileViewController.h"
#import "DWSession.h"


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@interface DWProfileNavigationViewController() {
    DWProfileViewController *_profileViewController;
}

/**
 * Table view controller for displaying the profile.
 */
@property (nonatomic,strong) DWProfileViewController *profileViewController;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWProfileNavigationViewController

@synthesize profileViewController = _profileViewController;

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
    
    self.navigationItem.title = @"Profile";
    
    
    if(!self.profileViewController) {
        self.profileViewController = [[DWProfileViewController alloc] initWithUser:[DWSession sharedDWSession].currentUser];
        self.profileViewController.delegate = self;
    }
    
    [self.view addSubview:self.profileViewController.view];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
