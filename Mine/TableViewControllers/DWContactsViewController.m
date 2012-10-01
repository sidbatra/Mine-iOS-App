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
#import "DWAnalyticsManager.h"
#import "DWErrorView.h"
#import "DWConstants.h"


static NSString* const kMsgErrorTitle       = @"Error";
static NSString* const kMsgCancelTitle      = @"OK";
static NSString* const kMsgError            = @"Mine needs access to your contacts for invites. You can update your settings. Setting -> Privacy -> Contacts";

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
    
    self.view.backgroundColor   = [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1.0];
    self.loadingView.hidden     = YES;
    
    [self adjustSupportingViewsY:106];
    
    [self disablePullToRefresh];
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
        DWDebug(@"contact deletion cancelled");
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
- (void)contactsPermissionDenied {
    self.loadingView.hidden = YES;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kMsgErrorTitle
                                                    message:kMsgError
                                                   delegate:nil
                                          cancelButtonTitle:kMsgCancelTitle
                                          otherButtonTitles:nil];
    [alert show];
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Contacts Permission Denied"];
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
