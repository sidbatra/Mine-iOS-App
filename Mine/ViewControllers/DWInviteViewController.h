//
//  DWInvitePeopleViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>

#import "DWContactsViewController.h"

@protocol DWInviteViewControllerDelegate;

/**
 * View for adding people throughout the app.
 */
@interface DWInviteViewController : UIViewController<UITextFieldDelegate,DWContactsViewControllerDelegate> {
    UITextField                 *_searchContactsTextField;          
    
    DWContactsViewController    *_queryContactsViewController;
    DWContactsViewController    *_addedContactsViewController;    
        
    __weak id <DWInviteViewControllerDelegate,NSObject> _delegate;
}

/**
 * IBOutlet properties
 */
@property (nonatomic) IBOutlet UITextField *searchContactsTextField;

/**
 * Controllers for quering and added contacts from the address book
 */
@property (nonatomic,strong) DWContactsViewController *queryContactsViewController;
@property (nonatomic,strong) DWContactsViewController *addedContactsViewController;

/**
 * Delegate
 */
@property (nonatomic,weak) id<DWInviteViewControllerDelegate,NSObject> delegate;


/**
 * IBActions
 */
- (IBAction)searchContactsTextFieldEditingChanged:(id)sender;

@end


/**
 * Protocol for delegates of DWInviteViewController
 */
@protocol DWInviteViewControllerDelegate

@optional

/*
 * Fired when the user decides to skip invite
 */
- (void)inviteSkipped;

/*
 * Fired when people are invited to use the app.
 */
- (void)peopleInvited;

@end