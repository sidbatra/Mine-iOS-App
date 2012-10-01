//
//  DWContactsController.m
//  Mine
//
//  Created by Deepak Rao on 7/26/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWContactsController.h"
#import "ABContactsHelper.h"
#import "DWContact.h"
#import "DWConstants.h"


static NSString* const kContactsQuery   = @"email contains[cd] %@ OR fullName contains[cd] %@";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWContactsController

@synthesize delegate = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        //custom initialization
    }
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    DWDebug(@"Contacts controller released");    
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Private Methods

//----------------------------------------------------------------------------------------------------
- (NSMutableArray*)getContactsWithEmail:(NSArray*)contacts {
    
    NSMutableArray  *dWContacts     = [NSMutableArray array];
    
    for(id contact in contacts) {
        for(id email in [contact emailArray]) {
            DWContact *dWContact    = [[DWContact alloc] init];
            
            dWContact.firstName     = [[contact firstname] length] == 0         ?   @"" : [contact firstname] ;
            dWContact.lastName      = [[contact lastname] length] == 0          ?   @"" : [contact lastname];
            
            dWContact.fullName      = [NSString stringWithFormat:@"%@ %@",dWContact.firstName,dWContact.lastName];
            dWContact.email         = email;
            
            [dWContacts addObject:dWContact];
        }
    }
    
    return dWContacts;
}

//----------------------------------------------------------------------------------------------------
- (void)contactsPermissionAccepted:(ABAddressBookRef)addressBook {
    
    NSArray *contacts           = [ABContactsHelper contactsFromAddressBook:addressBook];
    NSMutableArray *dWContacts  = [self getContactsWithEmail:contacts];
    
    [self.delegate allContactsLoaded:dWContacts];
}

//----------------------------------------------------------------------------------------------------
- (void)contactsPermissionDenied {
    [self.delegate contactsPermissionDenied];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Index

//----------------------------------------------------------------------------------------------------
- (void)getAllContacts {
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
        
        CFErrorRef error             = nil;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL,&error);
        
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    DWDebug(@"Error fetching contacts");
                }
                else if (!granted) {
                    [self contactsPermissionDenied];
                }
                else {
                    [self contactsPermissionAccepted:addressBook];
                }
            });
        });
    }    
    else {
        NSArray *contacts           = [ABContactsHelper contacts];
        NSMutableArray *dWContacts  = [self getContactsWithEmail:contacts];
        
        [self.delegate allContactsLoaded:dWContacts];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)getContactsForQuery:(NSString*)query withCache:(NSArray*)contacts {
    
    NSPredicate *pred       = [NSPredicate predicateWithFormat:kContactsQuery,query,query];
	NSMutableArray *results = [NSMutableArray arrayWithArray:[contacts filteredArrayUsingPredicate:pred]];
    
    [self.delegate contactsLoaded:results fromQuery:query];
}

@end

