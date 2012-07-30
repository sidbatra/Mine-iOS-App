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
    NSLog(@"Contacts controller released");    
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Index

//----------------------------------------------------------------------------------------------------
- (void)getAllContacts {
    
    SEL sel = @selector(allContactsLoaded:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    NSArray *contacts               = [ABContactsHelper contacts];
    NSMutableArray  *dWContacts     = [NSMutableArray arrayWithCapacity:[contacts count]];    
    
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
    
    [self.delegate performSelector:sel 
                        withObject:dWContacts]; 
}


//----------------------------------------------------------------------------------------------------
- (void)getContactsForQuery:(NSString*)query withCache:(NSArray*)contacts {
    
    SEL sel = @selector(contactsLoaded:fromQuery:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    NSPredicate *pred       = [NSPredicate predicateWithFormat:kContactsQuery,query,query];
	NSMutableArray *results = [NSMutableArray arrayWithArray:[contacts filteredArrayUsingPredicate:pred]];
    
    [self.delegate performSelector:sel
                        withObject:results 
                        withObject:query]; 
}

@end

