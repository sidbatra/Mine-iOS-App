//
//  DWContactsDataSource.h
//  Mine
//
//  Created by Deepak Rao on 7/27/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWTableViewDataSource.h"
#import "DWContactsController.h"
#import "DWInvitesController.h"

@class DWContact;
@protocol DWContactsDataSourceDelegate;

/**
 * Data source for the contacts table view controller
 */
@interface DWContactsDataSource : DWTableViewDataSource<DWContactsControllerDelegate,DWInvitesControllerDelegate> {
    
    NSMutableArray              *_allContacts;
    NSString                    *_latestQuery;
    
    DWContactsController        *_contactsController;
    DWInvitesController         *_invitesController;    
}

/**
 * Redefined delegate object
 */
@property (nonatomic,weak) id<DWContactsDataSourceDelegate,DWTableViewDataSourceDelegate,NSObject> delegate;


/**
 * All Address Book Contacts
 */
@property (nonatomic,strong) NSMutableArray *allContacts;

/**
 * Latest query for retrieving contacts
 */
@property (nonatomic,copy) NSString *latestQuery;

/**
 * Controller for address book contacts requests
 */
@property (nonatomic,strong) DWContactsController *contactsController;

/**
 * Interface to invite service
 */
@property (nonatomic,strong) DWInvitesController *invitesController;


/*
 * Load all contacts from the address book
 */
- (void)loadAllContacts;

/*
 * Load contacts whose properties contain a 
 * given string
 */
- (void)loadContactsMatching:(NSString*)string;

/*
 * Add the given contact at the end of objects array
 */
- (void)addContact:(DWContact*)contact;

/*
 * Remove the given contact from the objects array
 */
- (void)removeContact:(DWContact*)contact;

/*
 * Remove the given contact from all contacts cache
 */
- (void)removeContactFromCache:(DWContact*)contact;

/*
 * Add the given contact to all contacts cache
 */
- (void)addContactToCache:(DWContact*)contact;

/**
 * Send invite information to server
 */
- (void)triggerInvites;

@end


/**
 * Additional delegate methods for the data source
 */
@protocol DWContactsDataSourceDelegate<DWTableViewDataSourceDelegate>

/**
 * Fired when all the contacts are loaded
 */
- (void)allContactsLoaded;

/**
 * Fired when the queried contacts are loaded
 */
- (void)contactsLoadedFromQuery;

/**
 * Provide the fetched user object to the table view to update the UI
 */
- (void)invitesCreated;

/**
 * Fired when there is an error while creating invites
 */
- (void)invitesCreationError:(NSString*)error;

@end

