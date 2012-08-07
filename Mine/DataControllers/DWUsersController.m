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
static NSString* const kGetFollowersURI                 = @"/users.json?aspect=followers&user_id=%d";
static NSString* const kGetIFollowersURI                = @"/users.json?aspect=ifollowers&user_id=%d";


static NSString* const kUpdateUserFacebookTokenURI      = @"/users/%d.json?access_token=%@";
static NSString* const kUpdateUserTumblrTokenURI        = @"/users/%d.json?tumblr_access_token=%@&tumblr_access_token_secret=%@";
static NSString* const kUpdateUserTwitterTokenURI       = @"/users/%d.json?tw_access_token=%@&tw_access_token_secret=%@";


static NSString* const kNNewUserCreated         = @"NUserCreated";
static NSString* const kNNewUserCreateError     = @"NUserCreateError";

static NSString* const kNUserLoaded             = @"NUserLoad";
static NSString* const kNUserLoadError          = @"NUserLoadError";
static NSString* const kNLikersLoaded           = @"NLikersLoaded";
static NSString* const kNLikersLoadError        = @"NLikersLoadError";
static NSString* const kNFollowersLoaded        = @"NFollowersLoaded";
static NSString* const kNFollowersLoadError     = @"NFollowersLoadError";
static NSString* const kNIFollowersLoaded       = @"NIFollowersLoaded";
static NSString* const kNIFollowersLoadError    = @"NIFollowersLoadError";

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
												 selector:@selector(usersLoaded:) 
													 name:kNFollowersLoaded
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(usersLoadError:) 
													 name:kNFollowersLoadError
												   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(usersLoaded:) 
													 name:kNIFollowersLoaded
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(usersLoadError:) 
													 name:kNIFollowersLoadError
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
- (void)getFollowersForUserID:(NSInteger)userID {
    NSString *localURL = [NSString stringWithFormat:kGetFollowersURI,userID];
    
    [[DWRequestManager sharedDWRequestManager] createAppRequest:localURL
                                            successNotification:kNFollowersLoaded
                                              errorNotification:kNFollowersLoadError
                                                  requestMethod:kGet
                                                   authenticate:YES
                                                     resourceID:userID];
}

//----------------------------------------------------------------------------------------------------
- (void)getIFollowersForUserID:(NSInteger)userID {
    NSString *localURL = [NSString stringWithFormat:kGetIFollowersURI,userID];
    
    [[DWRequestManager sharedDWRequestManager] createAppRequest:localURL
                                            successNotification:kNIFollowersLoaded
                                              errorNotification:kNIFollowersLoadError
                                                  requestMethod:kGet
                                                   authenticate:YES
                                                     resourceID:userID];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Update

//----------------------------------------------------------------------------------------------------
- (void)updateUserHavingID:(NSInteger)userID 
   withFacebookAccessToken:(NSString *)facebookToken {
    
    NSString *localURL = [NSString stringWithFormat:kUpdateUserFacebookTokenURI,
                          userID,
                          [facebookToken stringByEncodingHTMLCharacters]];
    
    [[DWRequestManager sharedDWRequestManager] createAppRequest:localURL
                                            successNotification:kNUserUpdated
                                              errorNotification:kNUserUpdateError
                                                  requestMethod:kPut
                                                   authenticate:YES];
}

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
- (void)updateUserHavingID:(NSInteger)userID 
          withTwitterToken:(NSString *)twitterToken 
          andTwitterSecret:(NSString *)twitterSecret {
    
    NSString *localURL = [NSString stringWithFormat:kUpdateUserTwitterTokenURI,
                          userID,
                          [twitterToken stringByEncodingHTMLCharacters],
                          [twitterSecret stringByEncodingHTMLCharacters]];
    
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
    
    SEL sel = @selector(userLoaded:withUserID:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    
    NSDictionary *info      = [notification userInfo];
    
    NSDictionary *response  = [info objectForKey:kKeyResponse];
    DWUser *user            = [DWUser create:response];    
    
    [self.delegate performSelector:sel
                        withObject:user
                        withObject:[info objectForKey:kKeyResourceID]];
}

//----------------------------------------------------------------------------------------------------
- (void)userLoadError:(NSNotification*)notification {
    
    SEL sel = @selector(userLoadError:withUserID:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    
    NSDictionary *info  = [notification userInfo];
    NSError *error      = [[notification userInfo] objectForKey:kKeyError];
    
    [self.delegate performSelector:sel
                        withObject:[error localizedDescription]
                        withObject:[info objectForKey:kKeyResourceID]];
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
    else if([notification.name isEqualToString:kNFollowersLoaded]) {
        sel = @selector(followersLoaded:forUserID:);
    }
    else if([notification.name isEqualToString:kNIFollowersLoaded]) {
        sel = @selector(ifollowersLoaded:forUserID:);
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
    else if([notification.name isEqualToString:kNFollowersLoadError]) {
        sel = @selector(followersLoadError:forUserID:);
    }
    else if([notification.name isEqualToString:kNIFollowersLoadError]) {
        sel = @selector(ifollowersLoadError:forUserID:);
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
