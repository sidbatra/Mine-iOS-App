//
//  DWContactsViewController.m
//  Mine
//
//  Created by Deepak Rao on 7/27/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWContactsViewController.h"
#import "NSObject+Helpers.h"
#import "DWContact.h"
#import "DWContactPresenter.h"
#import "DWLoadingView.h"
#import "DWErrorView.h"
#import "DWConstants.h"


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWContactsViewController

@synthesize contactToRemove             = _contactToRemove;
@synthesize delegate                    = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)initWithPresentationStyle:(NSInteger)style {
    self = [super init];
    
    if(self) {        
        self.tableViewDataSource = [[DWContactsDataSource alloc] init];
        
        [self addModelPresenterForClass:[DWContact class]
                              withStyle:style 
                          withPresenter:[DWContactPresenter class]];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark View Lifecyle

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
    
    self.loadingView.hidden = YES;    
    
    [self disablePullToRefresh];
}

//----------------------------------------------------------------------------------------------------
- (UIView*)tableLoadingView {
    return [[DWLoadingView alloc] initWithFrame:CGRectMake(0,-44,320,339)];
}

//----------------------------------------------------------------------------------------------------
- (UIView*)tableErrorView {
    DWErrorView *errorView  = [[DWErrorView alloc] initWithFrame:CGRectMake(0,0,320,273)];
    errorView.delegate      = self;
    
    return errorView;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Datasource Methods

//----------------------------------------------------------------------------------------------------
- (void)loadAllContacts {
    self.loadingView.hidden = NO;    
    [(DWContactsDataSource*)self.tableViewDataSource loadAllContacts];
}

//----------------------------------------------------------------------------------------------------
- (void)loadContactsMatching:(NSString *)string {
    [(DWContactsDataSource*)self.tableViewDataSource loadContactsMatching:string];
}

//----------------------------------------------------------------------------------------------------
- (void)addContact:(DWContact *)contact {
    [(DWContactsDataSource*)self.tableViewDataSource addContact:contact];
}

//----------------------------------------------------------------------------------------------------
- (void)removeContact:(DWContact *)contact {
    [(DWContactsDataSource*)self.tableViewDataSource removeContact:contact];
}

//----------------------------------------------------------------------------------------------------
- (void)addContactToCache:(DWContact *)contact {
    [(DWContactsDataSource*)self.tableViewDataSource addContactToCache:contact];
}

//----------------------------------------------------------------------------------------------------
- (void)removeContactFromCache:(DWContact *)contact {
    [(DWContactsDataSource*)self.tableViewDataSource removeContactFromCache:contact];
}

//----------------------------------------------------------------------------------------------------
- (void)triggerInvites {
    self.errorView.hidden = YES;
    [(DWContactsDataSource*)self.tableViewDataSource triggerInvites];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark ActionSheet Methods

//----------------------------------------------------------------------------------------------------
- (void)showActionSheetInView:(UIView*)view forRemoving:(DWContact*)contact {
    self.contactToRemove = contact;
    
    UIActionSheet *actionSheet  = [[UIActionSheet alloc] initWithTitle:nil 
                                                              delegate:self 
                                                     cancelButtonTitle:@"Cancel"
                                                destructiveButtonTitle:@"Delete"
                                                     otherButtonTitles:nil];
    
    [actionSheet showInView:view];
}

//----------------------------------------------------------------------------------------------------
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {	
	
    if (buttonIndex == 0) {
        [(DWContactsDataSource*)self.tableViewDataSource removeContact:self.contactToRemove];
        [self.delegate contactRemoved:self.contactToRemove];
    }
    else if(buttonIndex == 1) {
        NSLog(@"contact deletion cancelled");
    }
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWContactPresenterDelegate (Implemented via selectors)

//----------------------------------------------------------------------------------------------------
- (void)contactClicked:(id)contact {
    [self.delegate contactSelected:contact fromObject:self];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWContactDataSourceDelegate

//----------------------------------------------------------------------------------------------------
- (void)allContactsLoaded {
    self.loadingView.hidden = YES;
    [self.delegate allContactsLoaded];
}

//----------------------------------------------------------------------------------------------------
- (void)contactsLoadedFromQuery {
    [self performSelectorOnMainThread:@selector(reloadTableView) 
                           withObject:nil 
                        waitUntilDone:NO];
}

//----------------------------------------------------------------------------------------------------
- (void)invitesCreated {
    [self.delegate invitesTriggeredFromObject:self];
}

//----------------------------------------------------------------------------------------------------
- (void)invitesCreationError:(NSString*)error {    
    [self displayError:error withRefreshUI:YES];
    [self.delegate invitesTriggerErrorFromObject:self];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Error view delegate

//----------------------------------------------------------------------------------------------------
- (void)errorViewTouched {
    self.errorView.hidden = YES;    
    [self.delegate resendInvites];
}

@end
