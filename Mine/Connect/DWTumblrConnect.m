//
//  DWTumblrConnect.m
//  Mine
//
//  Created by Deepak Rao on 8/1/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWTumblrConnect.h"
#import "DWConstants.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTumblrConnect

@synthesize tumblrXAuth    	= _tumblrXAuth;
@synthesize delegate        = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    
    self = [super init];
    
    if(self) {
        self.tumblrXAuth = [[TumblrXAuth alloc] init];
        
        self.tumblrXAuth.consumerKey    = kTumblrConsumerKey;
        self.tumblrXAuth.consumerSecret = kTumblrConsumerSecret;
        self.tumblrXAuth.delegate       = self;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)authorizeWithUsername:(NSString *)username 
                  andPassword:(NSString *)password {
    
    self.tumblrXAuth.username = username;
    self.tumblrXAuth.password = password;
    
    [self.tumblrXAuth authorize];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark TumblrXAuthDelegate

//----------------------------------------------------------------------------------------------------
- (void)tumblrXAuthDidAuthorize:(TumblrXAuth *)twitterXAuth {
    SEL sel = @selector(tumblrAuthenticatedWithToken:andSecret:);
    
    if([_delegate respondsToSelector:sel])
        [_delegate performSelector:sel 
                        withObject:self.tumblrXAuth.token 
                        withObject:self.tumblrXAuth.tokenSecret];
}

//----------------------------------------------------------------------------------------------------
- (void)tumblrXAuthAuthorizationDidFail:(TumblrXAuth *)twitterXAuth {
    SEL sel = @selector(tumblrAuthenticationFailed);
    
    if([_delegate respondsToSelector:sel])
        [_delegate performSelector:sel];
}

@end

