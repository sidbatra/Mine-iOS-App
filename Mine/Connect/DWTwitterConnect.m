//
//  DWTwitterConnect.m
//  Mine
//
//  Created by Deepak Rao on 8/2/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWTwitterConnect.h"
#import "TwitterConsumer.h"
#import "TwitterToken.h"
#import "DWConstants.h"


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTwitterConnect

@synthesize consumer        = _consumer;
@synthesize authenticator   = _authenticator;
@synthesize delegate        = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.consumer = [[TwitterConsumer alloc] initWithKey:kTwitterOAuthConsumerKey 
                                                      secret:kTwitterOAuthConsumerSecret];
    }
    
    return self;
}


//----------------------------------------------------------------------------------------------------
- (void)authorizeWithUsername:(NSString *)username 
                  andPassword:(NSString *)password {
    
    self.authenticator              = [TwitterAuthenticator new];
    
    self.authenticator.consumer     = self.consumer;
    self.authenticator.username     = username;
    self.authenticator.password     = password;
    self.authenticator.delegate     = self;
    
    [self.authenticator authenticate];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark TwitterAuthenticatorDelegate

//----------------------------------------------------------------------------------------------------
- (void) twitterAuthenticator:(TwitterAuthenticator*)twitterAuthenticator
             didFailWithError:(NSError*)error {
    
    SEL sel = @selector(twAuthenticationFailed);
    
    if([_delegate respondsToSelector:sel])
        [_delegate performSelector:sel];
}

//----------------------------------------------------------------------------------------------------
- (void) twitterAuthenticator:(TwitterAuthenticator*)twitterAuthenticator
          didSucceedWithToken:(TwitterToken*)token {
    
    SEL sel = @selector(twAuthenticatedWithToken:andSecret:);
    
    if([_delegate respondsToSelector:sel])
        [_delegate performSelector:sel 
                        withObject:token.token 
                        withObject:token.secret];
}

@end
