//
//  DWUserDetailsViewController.m
//  Mine
//
//  Created by Siddharth Batra on 8/27/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWUserDetailsViewController.h"

@interface DWUserDetailsViewController() {
    NSArray *_genderDataSource;
}

/**
 * Available options for the gender ui element.
 */
@property (nonatomic,strong) NSArray *genderDataSource;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUserDetailsViewController

@synthesize genderDataSource        = _genderDataSource;
@synthesize emailTextField          = _emailTextField;
@synthesize genderSegmentedControl  = _genderSegmentedControl;
@synthesize delegate                = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if (self) {
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
    
    [self.delegate userDetailsUpdated];
    
    //NSLog(@"%@ %@",self.emailTextField.text,[self.genderDataSource objectAtIndex:self.genderSegmentedControl.selectedSegmentIndex]);
}


@end
