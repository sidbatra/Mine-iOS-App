//
//  DWInvitePeopleViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>

#import "DWContactsViewController.h"

/**
 * View for adding people throughout the app.
 */
@interface DWInviteViewController : UIViewController<UITextFieldDelegate,DWContactsViewControllerDelegate> {
    UITextField                 *_searchContactsTextField;    
    UIView                      *_loadingView;
    
    DWContactsViewController    *_queryContactsViewController;
    DWContactsViewController    *_addedContactsViewController;
}

/**
 * IBOutlet properties
 */
@property (nonatomic) IBOutlet UITextField *searchContactsTextField;
@property (nonatomic) IBOutlet UIView *loadingView;

/**
 * Controllers for quering and added contacts from the address book
 */
@property (nonatomic,strong) DWContactsViewController *queryContactsViewController;
@property (nonatomic,strong) DWContactsViewController *addedContactsViewController;

/**
 * IBActions
 */
- (IBAction)searchContactsTextFieldEditingChanged:(id)sender;

@end