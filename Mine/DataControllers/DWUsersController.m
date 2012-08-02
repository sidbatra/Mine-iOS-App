//
//  DWUsersController.m
//  Mine
//
//  Created by Siddharth Batra on 7/20/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWUsersController.h"

#import "DWCryptography.h"
#import "NSString+Helpers.h"

#import "DWRequestManager.h"
#import "DWConstants.h"
#import "DWSession.h"


static NSString* const kNewUserURI                      = @"/users.json?using=facebook&access_token=%@&src=iphone";
static NSString* const kGetUserURI                      = @"/users/%@.json?";
static NSString* const kGetLikersURI                    = @"/users.json?aspect=likers&purchase_id=%d";
static NSString* const kUpdateUserTumblrTokenURI        = @"/users/%d.json?tumblr_access_token=%@&tumblr_access_token_secret=%@";


static NSString* const kNNewUserCreated         = @"NUserCreated";
static NSString* const kNNewUserCreateError     = @"NUserCreateError";

static NSString* const kNUserLoaded             = @"NUserLoad";
static NSString* const kNUserLoadError          = @"NUserLoadError";
static NSString* const kNLikersLoaded           = @"NLikersLoaded";
static NSString* const kNLikersLoadError        = @"NLikersLoadError";

static NSString* const kNUserUpdated            = @"NUserUpdated";
static NSString* const kNUserUpdateError        = @"NUserUpdateError";


/**
 * Private declarations
 */
@interface DWUsersController()

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUsersController

@synthesize delegate = _delegate;


//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(userCreated:) 
													 name:kNNewUserCreated
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(userCreationError:) 
													 name:kNNewUserCreateError
												   object:nil];
   
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(userLoaded:) 
													 name:kNUserLoaded
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(userLoadError:) 
													 name:kNUserLoadError
												   object:nil];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(usersLoaded:) 
													 name:kNLikersLoaded
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(usersLoadError:) 
													 name:kNLikersLoadError
												   object:nil];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(userUpdated:) 
													 name:kNUserUpdated
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(userUpdateError:) 
													 name:kNUserUpdateError
												   object:nil];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"Users controller released"); 
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Create

//----------------------------------------------------------------------------------------------------
- (void)createUserFromFacebookWithAccessToken:(NSString*)accessToken {
    
    NSString *localURL = [NSString stringWithFormat:kNewUserURI,
                          [accessToken stringByEncodingHTMLCharacters]];
    
    [[DWRequestManager sharedDWRequestManager] createAppRequest:localURL
                                            successNotification:kNNewUserCreated
                                              errorNotification:kNNewUserCreateError
                                                  requestMethod:kPost
                                                   authenticate:NO];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Show

//----------------------------------------------------------------------------------------------------
- (void)getUserWithID:(NSInteger)userID; {
    NSString *localURL = [NSString stringWithFormat:kGetUserURI,[DWCryptography obfuscate:userID]];

    [[DWRequestManager sharedDWRequestManager] createAppRequest:localURL
                                            successNotification:kNUserLoaded
                                              errorNotification:kNUserLoadError
                                                  requestMethod:kGet
                                                   authenticate:NO
                                                     resourceID:userID];
}

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Index

//----------------------------------------------------------------------------------------------------
- (void)getLikersForPurchaseID:(NSInteger)purchaseID {
    NSString *localURL = [NSString stringWithFormat:kGetLikersURI,purchaseID];
    
    [[DWRequestManager sharedDWRequestManager] createAppRequest:localURL
                                            successNotification:kNLikersLoaded
                                              errorNotification:kNLikersLoadError
                                                  requestMethod:kGet
                                                   authenticate:YES
                                                     resourceID:purchaseID];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Update

//----------------------------------------------------------------------------------------------------
- (void)updateUserHavingID:(NSInteger)userID 
           withTumblrToken:(NSString *)tumblrToken 
           andTumblrSecret:(NSString *)tumblrSecret {
    
    NSString *localURL = [NSString stringWithFormat:kUpdateUserTumblrTokenURI,
                          userID,
                          [tumblrToken stringByEncodingHTMLCharacters],
                          [tumblrSecret stringByEncodingHTMLCharacters]];
    
    [[DWRequestManager sharedDWRequestManager] createAppRequest:localURL
                                            successNotification:kNUserUpdated
                                              errorNotification:kNUserUpdateError
                                                  requestMethod:kPut
                                                   authenticate:YES];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Create notifications

//----------------------------------------------------------------------------------------------------
- (void)userCreated:(NSNotification*)notification {

    SEL sel = @selector(userCreated:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    NSDictionary *info      = [notification userInfo];
    NSDictionary *response  = [info objectForKey:kKeyResponse];
    DWUser *user            = [DWUser create:response];   
    
    [self.delegate performSelector:sel
                        withObject:user];
}

//----------------------------------------------------------------------------------------------------
- (void)userCreationError:(NSNotification*)notification {
    
    SEL sel = @selector(userCreationError:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    NSError *error = [[notification userInfo] objectForKey:kKeyError];
    
    [self.delegate performSelector:sel 
                        withObject:[error localizedDescription]];
}



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Update notifications

//----------------------------------------------------------------------------------------------------
- (void)userUpdated:(NSNotification*)notification {
    
    SEL sel = @selector(userUpdated:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    NSDictionary *info      = [notification userInfo];
    NSDictionary *response  = [info objectForKey:kKeyResponse];
    DWUser *user            = [DWUser create:response];   
    
    [self.delegate performSelector:sel
                        withObject:user];
}

//----------------------------------------------------------------------------------------------------
- (void)userUpdateError:(NSNotification*)notification {
    
    SEL sel = @selector(userUpdateError:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    NSError *error = [[notification userInfo] objectForKey:kKeyError];
    
    [self.delegate performSelector:sel 
                        withObject:[error localizedDescription]];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Show notifications

//----------------------------------------------------------------------------------------------------
- (void)userLoaded:(NSNotification*)notification {
    
    SEL idSel    = @selector(userResourceID);
    SEL usersSel = @selector(userLoaded:);
    
    if(![self.delegate respondsToSelector:usersSel] || ![self.delegate respondsToSelector:idSel])
        return;
    
    
    NSDictionary *info      = [notification userInfo];
    NSInteger resourceID    = [[info objectForKey:kKeyResourceID] integerValue];
    
    if(resourceID != (NSInteger)[self.delegate performSelector:idSel])
        return;
    
    
    NSDictionary *response  = [info objectForKey:kKeyResponse];
    DWUser *user            = [DWUser create:response];    
    
    [self.delegate performSelector:usersSel
                        withObject:user];
}

//----------------------------------------------------------------------------------------------------
- (void)userLoadError:(NSNotification*)notification {
    
    SEL idSel    = @selector(userResourceID);
    SEL errorSel = @selector(userLoadError:);
    
    if(![self.delegate respondsToSelector:errorSel] || ![self.delegate respondsToSelector:idSel])
        return;
    
    
    NSDictionary *userInfo  = [notification userInfo];
    NSInteger resourceID    = [[userInfo objectForKey:kKeyResourceID] integerValue];
    
    if(resourceID != (NSInteger)[self.delegate performSelector:idSel])
        return;
    
    
    NSError *error = [[notification userInfo] objectForKey:kKeyError];
    
    [self.delegate performSelector:errorSel 
                        withObject:[error localizedDescription]];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Index notifications

//----------------------------------------------------------------------------------------------------
- (void)usersLoaded:(NSNotification*)notification {
    
    SEL sel = nil;

    if([notification.name isEqualToString:kNLikersLoaded]) {
        sel = @selector(likersLoaded:forPurchaseID:);
    }
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    
    NSDictionary *info      = [notification userInfo];
    NSDictionary *response  = [info objectForKey:kKeyResponse];
    
    NSMutableArray *users   = [NSMutableArray arrayWithCapacity:[response count]];
    
    for(NSDictionary *user in response) {
        [users addObject:[DWUser create:user]];
    }
    
    
    [self.delegate performSelector:sel
                        withObject:users
                        withObject:[info objectForKey:kKeyResourceID]];
}

//----------------------------------------------------------------------------------------------------
- (void)usersLoadError:(NSNotification*)notification {
    
    SEL sel = nil;
    
    if([notification.name isEqualToString:kNLikersLoadError]) {
        sel = @selector(likersLoadError:forPurchaseID:);
    }
    
    if(![self.delegate respondsToSelector:sel])
        return;
        
    
    NSDictionary *userInfo  = [notification userInfo];
    NSError *error = [[notification userInfo] objectForKey:kKeyError];
    
    [self.delegate performSelector:sel
                        withObject:[error localizedDescription]
                        withObject:[userInfo objectForKey:kKeyResourceID]];
}

@end
