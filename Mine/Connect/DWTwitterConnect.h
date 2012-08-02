//
//  DWTwitterConnect.h
//  Mine
//
//  Created by Deepak Rao on 8/2/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "TwitterAuthenticator.h"

@class TwitterConsumer;
@protocol DWTwitterConnectDelegate;

/**
 * Wrapper over the Twitter XAuth Libs
 */
@interface DWTwitterConnect : NSObject<TwitterAuthenticatorDelegate> {
    TwitterConsumer         *_consumer;
    TwitterAuthenticator    *_authenticator;
    
    __weak id <DWTwitterConnectDelegate,NSObject> _delegate;
}

/**
 * Represents the API client
 */
@property (nonatomic,strong) TwitterConsumer *consumer;

/**
 * Performs authentications of behalf of the user
 */
@property (nonatomic,strong) TwitterAuthenticator *authenticator;

/**
 * DWTwitterConnectDelegate
 */
@property (nonatomic,weak) id<DWTwitterConnectDelegate,NSObject> delegate;


/**
 * Authorize Twitter with given username and password
 */
- (void)authorizeWithUsername:(NSString*)username
                  andPassword:(NSString*)password;

@end


/**
 * Delegate protocol to fire events about the Twitter authentication
 * and lifecycle
 */
@protocol DWTwitterConnectDelegate
- (void)twAuthenticating;
- (void)twAuthenticationFailed;
- (void)twAuthenticatedWithToken:(NSString*)token 
                       andSecret:(NSString*)secret;
@end

