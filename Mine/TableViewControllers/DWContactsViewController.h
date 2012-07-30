//
//  DWContactsViewController.h
//  Mine
//
//  Created by Deepak Rao on 7/27/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWTableViewController.h"
#import "DWContactsDataSource.h"

@class DWContact;
@protocol DWContactsViewControllerDelegate;


/**
 * Table view displaying search results
 */
@interface DWContactsViewController : DWTableViewController<UIActionSheetDelegate,DWContactsDataSourceDelegate> {
    DWContact *_contactToRemove;
    
    __weak id<DWContactsViewControllerDelegate> _delegate;
}

/**
 * Contact selected to be removed by the user
 */
@property (nonatomic,strong) DWContact *contactToRemove;

/**
 * Delegate based on the DWContactsViewControllerDelegate protocol
 */
@property (nonatomic,weak) id<DWContactsViewControllerDelegate> delegate;

/**
 * Custom init with style
 */
- (id)initWithPresentationStyle:(NSInteger)style;

/**
 * Load all contacts from the address book
 */
- (void)loadAllContacts;

/**
 * Load contacts whose properties contain a 
 * given string
 */
- (void)loadContactsMatching:(NSString*)string;

/**
 * Add the given contact to the datasource and the tableview
 */
- (void)addContact:(DWContact*)contact;

/**
 * Remove the given contact from the datasource and the tableview
 */
- (void)removeContact:(DWContact*)contact;

/**
 * Add the given contact to the datasource cache
 */
- (void)addContactToCache:(DWContact*)contact;

/**
 * Remove the given contact from the datasource cache
 */
- (void)removeContactFromCache:(DWContact*)contact;

/**
 * Show the action sheet to confirm removing a contact from 
 * the table view
 */
- (void)showActionSheetInView:(UIView*)view
                  forRemoving:(DWContact*)contact;

/**
 * Send invite information to server
 */
- (void)triggerInvites;

@end


/**
 * Protocol for delegates of DWContactsViewController
 */
@protocol DWContactsViewControllerDelegate

/**
 * Fired when all the contacts are loaded
 */
- (void)allContactsLoaded;

/**
 * Fired when a contact is selected along with 
 * object for the contactsviewcontroller
 */
- (void)contactSelected:(DWContact*)contact 
             fromObject:(id)object;

/**
 * Fired when a contact is removed from the 
 * added contacts list
 */
- (void)contactRemoved:(DWContact*)contact;

/**
 * Fired when the invite information is 
 * successfully sent to the server
 */
- (void)invitesTriggeredFromObject:(id)object;

/**
 * Fired when there is an error while creating invites
 */
- (void)invitesTriggerErrorFromObject:(id)object;

/**
 * Fired when the user decides to resend the 
 * invites in case of network failures
 */
- (void)resendInvites;

@end
