//
//  DWUserDetailsViewController.m
//  Mine
//
//  Created by Siddharth Batra on 8/27/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWUserDetailsViewController.h"
#import "DWSession.h"

@interface DWUserDetailsViewController() {
    DWUsersController   *_usersController;
    NSArray *_genderDataSource;
}

/**
 * Users data controller.
 */
@property (nonatomic,strong) DWUsersController *usersController;

/**
 * Available options for the gender ui element.
 */
@property (nonatomic,strong) NSArray *genderDataSource;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUserDetailsViewController

@synthesize usersController         = _usersController;
@synthesize genderDataSource        = _genderDataSource;
@synthesize emailTextField          = _emailTextField;
@synthesize genderSegmentedControl  = _genderSegmentedControl;
@synthesize delegate                = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if (self) {
        self.usersController = [[DWUsersController alloc] init];
        self.usersController.delegate = self;
        
        self.genderDataSource = [NSArray arrayWithObjects:@"male",@"female", nil];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" 
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self 
                                                                             action:@selector(proceedButtonClicked:)];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark IBActions

//----------------------------------------------------------------------------------------------------
- (void)proceedButtonClicked:(id)sender {
    
    if(!self.emailTextField.text.length) {
        return;
    }
    
    [self.usersController updateUserHavingID:[DWSession sharedDWSession].currentUser.databaseID
                                   withEmail:self.emailTextField.text
                                  withGender:[self.genderDataSource objectAtIndex:self.genderSegmentedControl.selectedSegmentIndex]];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWUsersControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)userUpdated:(DWUser *)user {
    [user destroy];
    [self.delegate userDetailsUpdated];
}

//----------------------------------------------------------------------------------------------------
- (void)userUpdateError:(NSString *)error {
}


@end
