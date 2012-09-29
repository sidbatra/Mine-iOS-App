//
//  DWFacebookConnect.m
//  Mine
//
//  Created by Deepak Rao on 7/23/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWFacebookConnect.h"
#import "DWConstants.h"

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWFacebookConnect

@synthesize facebook    	= _facebook;
@synthesize delegate        = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    
    self = [super init];
    
    if(self) {
        self.facebook = [[Facebook alloc] initWithAppId:kFacebookAppID 
                                            andDelegate:self];
        
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
- (void)authorize {
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"email",
                            @"user_likes", 
                            @"user_birthday",
                            @"publish_actions",
                            nil];
    
    [self.facebook authorize:permissions];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark FBSessionDelegate

//----------------------------------------------------------------------------------------------------
- (void)fbDidLogin {
    SEL sel = @selector(fbAuthenticatedWithToken:);
    
    if([_delegate respondsToSelector:sel])
        [_delegate performSelector:sel 
                        withObject:self.facebook.accessToken];
}

//----------------------------------------------------------------------------------------------------
- (void)fbDidNotLogin:(BOOL)cancelled {
    SEL sel = @selector(fbAuthenticationFailed);
    
    if([_delegate respondsToSelector:sel])
        [_delegate performSelector:sel];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)facebookURLOpened:(NSNotification*)notification {
    [self.facebook handleOpenURL:(NSURL*)[notification object]];
}

@end
