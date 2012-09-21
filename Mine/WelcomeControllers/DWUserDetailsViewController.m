//
//  DWUserDetailsViewController.m
//  Mine
//
//  Created by Siddharth Batra on 8/27/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWUserDetailsViewController.h"
#import "DWGUIManager.h"
#import "DWSession.h"


static NSString* const kExampleText = @"Example: '%@ bought %@ iPhone 5...'";

/**
 *
 */
@interface DWUserDetailsViewController() {
    DWUsersController   *_usersController;
    
    NSInteger   _selectedButtonIndex;
    NSArray     *_genderDataSource;
}

/**
 * Users data controller.
 */
@property (nonatomic,strong) DWUsersController *usersController;


/**
 * Selected Button Index
 */
@property (nonatomic,assign) NSInteger selectedButtonIndex;

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
@synthesize selectedButtonIndex     = _selectedButtonIndex;
@synthesize genderDataSource        = _genderDataSource;
@synthesize titleLabel              = _titleLabel;
@synthesize exampleLabel            = _exampleLabel;
@synthesize emailTextField          = _emailTextField;
@synthesize maleButton              = _maleButton;
@synthesize femaleButton            = _femaleButton;
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
    
    self.navigationItem.titleView           = [DWGUIManager navBarTitleViewWithText:@"New Account"];
    self.navigationItem.rightBarButtonItem  = [DWGUIManager navBarDoneButtonWithTarget:self];  
    self.navigationItem.hidesBackButton     = YES;
    
    self.titleLabel.text    = [NSString stringWithFormat:@"Welcome %@!",[DWSession sharedDWSession].currentUser.firstName];
    self.exampleLabel.text  = [NSString stringWithFormat:kExampleText,[DWSession sharedDWSession].currentUser.firstName,@"his"];
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
- (void)maleButtonClicked:(id)sender {
    
    if(!self.maleButton.isSelected) {
        self.selectedButtonIndex    = 0;
        self.maleButton.selected    = YES;
        self.femaleButton.selected  = NO;
        
        self.exampleLabel.text      = [NSString stringWithFormat:kExampleText,[DWSession sharedDWSession].currentUser.firstName,@"his"];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)femaleButtonClicked:(id)sender {
    
    if(!self.femaleButton.isSelected) {
        self.selectedButtonIndex    = 1;
        self.femaleButton.selected  = YES;
        self.maleButton.selected    = NO;
        
        self.exampleLabel.text      = [NSString stringWithFormat:kExampleText,[DWSession sharedDWSession].currentUser.firstName,@"her"];        
    }
}

//----------------------------------------------------------------------------------------------------
- (void)doneButtonClicked {
    
    if(!self.emailTextField.text.length) {
        return;
    }
    
    [self.usersController updateUserHavingID:[DWSession sharedDWSession].currentUser.databaseID
                                   withEmail:self.emailTextField.text
                                  withGender:[self.genderDataSource objectAtIndex:self.selectedButtonIndex]];
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
