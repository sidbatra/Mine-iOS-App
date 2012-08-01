//
//  DWTumblrConnect.h
//  Mine
//
//  Created by Deepak Rao on 8/1/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TumblrXAuth.h"

@protocol DWTumblrConnectDelegate;

/**
 * Wrapper over the Tumblr xAuth for iOS
 */
@interface DWTumblrConnect : NSObject<TumblrXAuthDelegate> {
    TumblrXAuth *_tumblrXAuth; 
    
    __weak id<DWTumblrConnectDelegate,NSObject> _delegate;
}

/**
 * Tumblr iOS xAuth interface instance
 */
@property (nonatomic,strong) TumblrXAuth *tumblrXAuth;

/**
 * DWTumblrConnectDelegate
 */
@property (nonatomic,weak) id<DWTumblrConnectDelegate,NSObject> delegate;


/**
 * Authorize tumblr with given username(email) and password
 */
- (void)authorizeWithUsername:(NSString*)username
                  andPassword:(NSString*)password;

@end


/**
 * Protocol to fire events about the TumblrXAuth lifecycle
 */
@protocol DWTumblrConnectDelegate 

@optional

- (void)tumblrAuthenticatedWithToken:(NSString*)accessToken andSecret:(NSString*)secret;
- (void)tumblrAuthenticationFailed;

@end

