//
//  DWEditBylineViewController.m
//  Mine
//
//  Created by Siddharth Batra on 9/20/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWEditBylineViewController.h"

#import "DWGUIManager.h"
#import "DWNavigationBarBackButton.h"


@interface DWEditBylineViewController () {
    DWUsersController   *_usersController;
}

@property (nonatomic,strong) DWUsersController *usersController;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWEditBylineViewController

@synthesize usersController = _usersController;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if (self) {
        self.usersController = [[DWUsersController alloc] init];
        self.usersController.delegate = self;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [DWNavigationBarBackButton backButtonForNavigationController:self.navigationController];
    self.navigationItem.titleView  = [DWGUIManager navBarTitleViewWithText:@"Edit Bio"];   
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
}

//----------------------------------------------------------------------------------------------------
- (void)showSpinner {
    
}

//----------------------------------------------------------------------------------------------------
- (void)hideSpinner {
    
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWUsersControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)userUpdated:(DWUser*)user {
    [user destroy];
    [self hideSpinner];
}

//----------------------------------------------------------------------------------------------------
- (void)userUpdateError:(NSString *)error {
    [self hideSpinner];
}



@end
