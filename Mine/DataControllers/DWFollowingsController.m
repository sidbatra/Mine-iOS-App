//
//  DWFollowingsController.m
//  Mine
//
//  Created by Siddharth Batra on 8/4/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWFollowingsController.h"

#import "DWRequestManager.h"
#import "DWFollowing.h"
#import "DWConstants.h"


static NSString* const kGetURI                  = @"/followings/%d.json?";
static NSString* const kCreateURI               = @"/followings.json?user_id=%d";
static NSString* const kDestroyURI              = @"/followings/%d.json?";

static NSString* const kNFollowingLoaded        = @"NFollowingLoaded";
static NSString* const kNFollowingLoadError     = @"NFollowingLoadError";
static NSString* const kNFollowingCreated       = @"NFollowingCreated";
static NSString* const kNFollowingCreateError   = @"NFollowingCreateError";
static NSString* const kNFollowingDestroyed     = @"NFollowingDestroyed";
static NSString* const kNFollowingDestroyError  = @"NFollowingDestroyError";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWFollowingsController

@synthesize delegate = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(followingLoaded:) 
													 name:kNFollowingLoaded
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(followingLoadError:) 
													 name:kNFollowingLoadError
												   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(followingCreated:) 
													 name:kNFollowingCreated
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(followingCreateError:) 
													 name:kNFollowingCreateError
												   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(followingDestroyed:) 
													 name:kNFollowingDestroyed
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(followingDestroyError:) 
													 name:kNFollowingDestroyError
												   object:nil];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"Followings controller released");
}

//----------------------------------------------------------------------------------------------------
- (void)getFollowingForUserID:(NSInteger)userID {

    NSString *localURL = [NSString stringWithFormat:kGetURI,userID];
    
    [[DWRequestManager sharedDWRequestManager] createAppRequest:localURL
                                            successNotification:kNFollowingLoaded
                                              errorNotification:kNFollowingLoadError
                                                  requestMethod:kGet
                                                   authenticate:YES
                                                     resourceID:userID];
}

//----------------------------------------------------------------------------------------------------
- (void)createFollowingForUserID:(NSInteger)userID {
    
    NSString *localURL = [NSString stringWithFormat:kCreateURI,userID];
    
    [[DWRequestManager sharedDWRequestManager] createAppRequest:localURL
                                            successNotification:kNFollowingCreated
                                              errorNotification:kNFollowingCreateError
                                                  requestMethod:kPost
                                                   authenticate:YES
                                                     resourceID:userID];    
}


//----------------------------------------------------------------------------------------------------
- (void)destroyFollowing:(NSInteger)followingID
               ForUserID:(NSInteger)userID {
    
    NSString *localURL = [NSString stringWithFormat:kDestroyURI,followingID];
    
    [[DWRequestManager sharedDWRequestManager] createAppRequest:localURL
                                            successNotification:kNFollowingDestroyed
                                              errorNotification:kNFollowingDestroyError
                                                  requestMethod:kDelete
                                                   authenticate:YES
                                                     resourceID:userID];    
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)followingLoaded:(NSNotification*)notification {
    
    SEL sel = @selector(followingLoaded:forUserID:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    
    NSDictionary *info          = [notification userInfo];
    NSDictionary *response      = [info objectForKey:kKeyResponse];
    DWFollowing *following      = nil;
    
    if(response && [response count])
        following = [DWFollowing create:response];
    
    [self.delegate performSelector:sel
                        withObject:following
                        withObject:[info objectForKey:kKeyResourceID]];
}

//----------------------------------------------------------------------------------------------------
- (void)followingLoadError:(NSNotification*)notification {
    
    SEL sel = @selector(followingLoadError:forUserID:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    
    NSDictionary *info  = [notification userInfo];
    NSError *error      = [info objectForKey:kKeyError];
    
    [self.delegate performSelector:sel 
                        withObject:[error localizedDescription]
                        withObject:[info objectForKey:kKeyResourceID]];
}


//----------------------------------------------------------------------------------------------------
- (void)followingCreated:(NSNotification*)notification {
    
    SEL sel = @selector(followingCreated:forUserID:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    
    NSDictionary *info          = [notification userInfo];
    NSDictionary *response      = [info objectForKey:kKeyResponse];
    DWFollowing *following      = nil;
    
    if(response && [response count])
        following = [DWFollowing create:response];
    
    
    [self.delegate performSelector:sel
                        withObject:following
                        withObject:[info objectForKey:kKeyResourceID]];
}

//----------------------------------------------------------------------------------------------------
- (void)followingCreateError:(NSNotification*)notification {
    
    SEL sel = @selector(followingCreateError:forUserID:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    
    NSDictionary *info  = [notification userInfo];
    NSError *error      = [info objectForKey:kKeyError];
    
    [self.delegate performSelector:sel 
                        withObject:[error localizedDescription]
                        withObject:[info objectForKey:kKeyResourceID]];
}


//----------------------------------------------------------------------------------------------------
- (void)followingDestroyed:(NSNotification*)notification {
    
    SEL sel = @selector(followingDestroyed:forUserID:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    
    NSDictionary *info          = [notification userInfo];
    NSDictionary *response      = [info objectForKey:kKeyResponse];
    DWFollowing *following      = nil;
    
    if(response && [response count])
        following = [DWFollowing create:response];
    
    
    [self.delegate performSelector:sel
                        withObject:following
                        withObject:[info objectForKey:kKeyResourceID]];
}

//----------------------------------------------------------------------------------------------------
- (void)followingDestroyError:(NSNotification*)notification {
    
    SEL sel = @selector(followingDestroyError:forUserID:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    
    NSDictionary *info  = [notification userInfo];
    NSError *error      = [info objectForKey:kKeyError];
    
    [self.delegate performSelector:sel 
                        withObject:[error localizedDescription]
                        withObject:[info objectForKey:kKeyResourceID]];
}

@end
