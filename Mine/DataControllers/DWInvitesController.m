//
//  DWInvitesController.m
//  Mine
//
//  Created by Deepak Rao on 7/26/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWInvitesController.h"
#import "DWRequestManager.h"
#import "DWConstants.h"
#import "DWContact.h"


static NSString* const kNewInvitesURI           = @"/invites.json?";

static NSString* const kNInvitesCreated         = @"NInvitesCreated";
static NSString* const kNInvitesCreateError     = @"NInvitesCreateError";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWInvitesController

@synthesize delegate    = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(invitesCreated:) 
                                                     name:kNInvitesCreated
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(invitesCreationError:) 
                                                     name:kNInvitesCreateError
                                                   object:nil];
    }
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    DWDebug(@"Invites controller released");    
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Private Methods

//----------------------------------------------------------------------------------------------------
- (NSMutableDictionary*)inviteParamFrom:(NSArray*)contacts {
    
    NSMutableDictionary *dict   = [NSMutableDictionary dictionary];
    NSInteger counter           = 0;
    
    for(id contact in contacts) {
        [dict setObject:[(DWContact*)contact email]     
                 forKey:[NSString stringWithFormat:@"invites[%d][recipient_id]",counter]];
        
        [dict setObject:[(DWContact*)contact fullName]  
                 forKey:[NSString stringWithFormat:@"invites[%d][recipient_name]",counter]];
        
        [dict setObject:[NSString stringWithFormat:@"%d",DWInvitePlatformEmail]           
                 forKey:[NSString stringWithFormat:@"invites[%d][platform]",counter]];
        
        counter++;
    }
    
    return dict;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Create

//----------------------------------------------------------------------------------------------------
- (void)createInvitesFrom:(NSArray*)contacts {

    NSMutableDictionary *params = [self inviteParamFrom:contacts];

    [[DWRequestManager sharedDWRequestManager] createPostBodyBasedAppRequest:kNewInvitesURI 
                                                                  withParams:params 
                                                         successNotification:kNInvitesCreated 
                                                           errorNotification:kNInvitesCreateError
                                                                authenticate:YES
                                                              uploadDelegate:nil];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)invitesCreated:(NSNotification*)notification {

    SEL sel = @selector(invitesCreated);
    
    if(![self.delegate respondsToSelector:sel])
        return;

    //NSDictionary *info      = [notification userInfo];
    //NSDictionary *response  = [info objectForKey:kKeyResponse];
    
    [self.delegate performSelector:sel];
}

//----------------------------------------------------------------------------------------------------
- (void)invitesCreationError:(NSNotification*)notification {
    
    SEL sel = @selector(invitesCreationError:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    NSError *error = [[notification userInfo] objectForKey:kKeyError];
    
    [self.delegate performSelector:sel 
                        withObject:[error localizedDescription]];
}

@end
