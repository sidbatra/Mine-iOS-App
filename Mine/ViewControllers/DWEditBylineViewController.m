//
//  DWEditBylineViewController.m
//  Mine
//
//  Created by Siddharth Batra on 9/20/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWEditBylineViewController.h"

#import "DWGUIManager.h"
#import "DWAnalyticsManager.h"
#import "DWNavigationBarBackButton.h"

#import "DWSession.h"


static NSInteger const kMaxBylineLength = 160;


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
@synthesize bylineTextView  = _bylineTextView;
@synthesize spinnerView     = _spinnerView;

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
    
    self.bylineTextView.text = [DWSession sharedDWSession].currentUser.byline;
    
    self.navigationItem.leftBarButtonItem = [DWNavigationBarBackButton backButtonForNavigationController:self.navigationController];
    self.navigationItem.rightBarButtonItem = [DWGUIManager navBarSaveButtonWithTarget:self];  
    self.navigationItem.titleView  = [DWGUIManager navBarTitleViewWithText:@"Edit Bio"];
    
    [self.bylineTextView becomeFirstResponder];
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Byline Edit View"];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
}

//----------------------------------------------------------------------------------------------------
- (void)showSpinner {
    self.view.userInteractionEnabled = NO;
    [self.spinnerView startAnimating];
}

//----------------------------------------------------------------------------------------------------
- (void)hideSpinner {
    self.view.userInteractionEnabled = YES;    
    [self.spinnerView stopAnimating];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UITextViewDelegate

//----------------------------------------------------------------------------------------------------
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return ([textView.text length] + [text length] - range.length > kMaxBylineLength) || [text isEqualToString:@"\n"] ? NO : YES;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UI Events

//----------------------------------------------------------------------------------------------------
- (void)saveButtonClicked {
    if([self.spinnerView isAnimating])
        return;

    [self showSpinner];
    
    [self.usersController updateUserHavingID:[DWSession sharedDWSession].currentUser.databaseID
                                  withByline:self.bylineTextView.text];
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Byline Edited"];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWUsersControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)userUpdated:(DWUser*)user {
    [user destroy];
    [self hideSpinner];
    [self.navigationController popViewControllerAnimated:YES];
}

//----------------------------------------------------------------------------------------------------
- (void)userUpdateError:(NSString *)error {
    [self hideSpinner];
    [self.bylineTextView becomeFirstResponder];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav stack selectors

//----------------------------------------------------------------------------------------------------
- (void)requiresFullScreenMode {
    
}

//----------------------------------------------------------------------------------------------------
- (void)hideTopShadowOnTabBar {

}

@end
