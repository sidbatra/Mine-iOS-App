//
//  DWFacebookConnect.m
//  Mine
//
//  Created by Deepak Rao on 7/23/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWFacebookConnect.h"
#import "DWConstants.h"

#import <FacebookSDK/FacebookSDK.h>



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWFacebookConnect

@synthesize delegate        = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    
    self = [super init];
    
    if(self) {
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(facebookURLOpened:) 
													 name:kNFacebookURLOpened
												   object:nil];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    DWDebug(@"Facebook Connect released");
}

//----------------------------------------------------------------------------------------------------
- (void)authorizeRead {
    [FBSession.activeSession closeAndClearTokenInformation];
    
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"email",
                            @"user_likes",
                            @"user_birthday",
                            nil];
    [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:YES
                                  completionHandler:^(FBSession *session,
                                                         FBSessionState state,
                                                         NSError *error) {
                                         [self sessionReadStateChanged:session
                                                                 state:state
                                                                 error:error];}];
}

//----------------------------------------------------------------------------------------------------
- (void)authorizeWrite {
    NSArray *permissions = [[NSArray alloc] initWithObjects:@"publish_actions",nil];
     
    [[FBSession activeSession] reauthorizeWithPublishPermissions:permissions
                                                 defaultAudience:FBSessionDefaultAudienceFriends
                                               completionHandler:^(FBSession *session, NSError *error) {
                                                   [self sessionWriteStateChanged:session
                                                                            error:error];
                                                }];
}

//----------------------------------------------------------------------------------------------------
- (void)sessionReadStateChanged:(FBSession *)session
                          state:(FBSessionState) state
                          error:(NSError *)error {
    
    switch (state) {
        case FBSessionStateOpen:
            
            if (!error) {
                SEL sel = @selector(fbReadAuthenticatedWithToken:);
                
                if([_delegate respondsToSelector:sel])
                    [_delegate performSelector:sel
                                    withObject:session.accessToken];
            }
            
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            
            SEL sel = @selector(fbAuthenticationFailed);
            
            if([_delegate respondsToSelector:sel])
                [_delegate performSelector:sel];
            
            break;
        default:
            break;
    }
    
    if (error)
        NSLog(@"FB Read Error: %@",error.localizedDescription);
}

//----------------------------------------------------------------------------------------------------
- (void)sessionWriteStateChanged:(FBSession*)session error:(NSError*)error {
    
    if(!error) {
        SEL sel = @selector(fbWriteAuthenticatedWithToken:);
        
        if([_delegate respondsToSelector:sel])
            [_delegate performSelector:sel
                            withObject:session.accessToken];
    }
    else {
        SEL sel = @selector(fbAuthenticationFailed);
        
        if([_delegate respondsToSelector:sel])
            [_delegate performSelector:sel];
        
        NSLog(@"FB Read Error: %@",error.localizedDescription);
    }
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)facebookURLOpened:(NSNotification*)notification {
    [FBSession.activeSession handleOpenURL:(NSURL*)[notification object]];
}

@end
