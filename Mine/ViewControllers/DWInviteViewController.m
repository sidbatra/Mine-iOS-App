//
//  DWInvitePeopleViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWInviteViewController.h"

#import "DWContact.h"
#import "ABContactsHelper.h"
#import "DWNavigationBarBackButton.h"
#import "DWGUIManager.h"
#import "DWConstants.h"


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWInviteViewController

@synthesize searchContactsTextField         = _searchContactsTextField;
@synthesize loadingView                     = _loadingView;
@synthesize queryContactsViewController     = _queryContactsViewController;
@synthesize addedContactsViewController     = _addedContactsViewController;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if (self) {
        self.queryContactsViewController            = [[DWContactsViewController alloc] initWithPresentationStyle:kPresentationStyleDefault];        
        self.queryContactsViewController.delegate   = self;
        
        self.addedContactsViewController            = [[DWContactsViewController alloc] initWithPresentationStyle:kContactPresenterStyleSelected];        
        self.addedContactsViewController.delegate   = self;
    }
    return self;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Private Methods

//----------------------------------------------------------------------------------------------------
- (void)freezeUI {	
    self.loadingView.hidden = NO;
    [self.view bringSubviewToFront:self.loadingView];
    
    self.navigationItem.rightBarButtonItem.enabled  = NO;    
}

//----------------------------------------------------------------------------------------------------
- (void)unfreezeUI {
    self.loadingView.hidden = YES; 
    
    self.navigationItem.rightBarButtonItem.enabled  = YES;    
}

//----------------------------------------------------------------------------------------------------
- (void)displayAddedContacts {
    self.queryContactsViewController.view.hidden    = YES;  
    self.addedContactsViewController.view.hidden    = NO;     
}

//----------------------------------------------------------------------------------------------------
- (void)displayQueriedContacts {
    self.queryContactsViewController.view.hidden    = NO;  
    self.addedContactsViewController.view.hidden    = YES;    
}

//----------------------------------------------------------------------------------------------------
- (void)loadAllContacts {
    
    @autoreleasepool {    
    
        [self.queryContactsViewController loadAllContacts];
    
    }    
}

//----------------------------------------------------------------------------------------------------
- (void)loadContacts:(NSString*)query {
    
    @autoreleasepool {
        [self.queryContactsViewController loadContactsMatching:[query stringByTrimmingCharactersInSet:
                                                                [NSCharacterSet whitespaceAndNewlineCharacterSet]]];    
    }
}

//----------------------------------------------------------------------------------------------------
- (void)displayInviteAlert {
    
}

//----------------------------------------------------------------------------------------------------
- (void)createInvites {
    
    if ([self.addedContactsViewController.tableView numberOfRowsInSection:0]) {
        [self freezeUI];
        [self.addedContactsViewController triggerInvites];            
    }
    else {
        [self displayInviteAlert];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)displayKeyboard {
    [self.searchContactsTextField becomeFirstResponder];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark View Lifecycle

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem           = [DWNavigationBarBackButton backButtonForNavigationController:self.navigationController];
    self.navigationItem.titleView                   = [DWGUIManager navBarTitleViewWithText:@"Invite Friends"];
    self.navigationItem.rightBarButtonItem          = [DWGUIManager navBarSendButtonWithTarget:self];
           
    self.queryContactsViewController.view.frame     = CGRectMake(0,44,320,200);
    self.addedContactsViewController.view.frame     = CGRectMake(0,44,320,200);

    [self.view addSubview:self.queryContactsViewController.view];    
    [self.view addSubview:self.addedContactsViewController.view];   
    
    [self displayQueriedContacts];
    [self performSelectorInBackground:@selector(loadAllContacts) 
                           withObject:nil];
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
- (IBAction)searchContactsTextFieldEditingChanged:(id)sender {

    if ([self.searchContactsTextField.text length]) {        
        [self displayQueriedContacts];    
        [self performSelectorInBackground:@selector(loadContacts:) 
                               withObject:self.searchContactsTextField.text];
    }
    else {
        [self displayAddedContacts];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)sendButtonClicked {
    [self createInvites];
}

//----------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    
	if(textField == self.searchContactsTextField)
        [self createInvites];
    
	return YES;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWContactsViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)contactSelected:(DWContact*)contact fromObject:(id)object {
    if ([object isEqual:self.queryContactsViewController ] ) {
        [self displayAddedContacts];
        [self.addedContactsViewController addContact:contact];
        [self.queryContactsViewController removeContactFromCache:contact];
        
        self.searchContactsTextField.text = @"";
    }
    else {        
        [self.addedContactsViewController showActionSheetInView:self.parentViewController.view
                                                    forRemoving:contact];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)allContactsLoaded {
    [self performSelectorOnMainThread:@selector(unfreezeUI) 
                           withObject:nil 
                        waitUntilDone:NO];
    
    [self performSelectorOnMainThread:@selector(displayKeyboard) 
                           withObject:nil 
                        waitUntilDone:NO];
}

//----------------------------------------------------------------------------------------------------
- (void)contactRemoved:(DWContact*)contact {
    [self.queryContactsViewController addContactToCache:contact];
}

//----------------------------------------------------------------------------------------------------
- (void)invitesTriggeredFromObject:(id)object {
    
    if ([object isEqual:self.addedContactsViewController]) {
        [self unfreezeUI];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)invitesTriggerErrorFromObject:(id)object {
    
    if ([object isEqual:self.addedContactsViewController]) {
        [self unfreezeUI];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)resendInvites {
    [self createInvites];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark FullScreenMode

//----------------------------------------------------------------------------------------------------
- (void)requiresFullScreenMode {
    
}

@end
