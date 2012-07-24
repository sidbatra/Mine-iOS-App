//
//  DWFacebookConnect.h
//  Mine
//
//  Created by Deepak Rao on 7/23/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FBConnect.h"

@protocol DWFacebookConnectDelegate;

/**
 * Wrapper over the Facebook iOS SDK
 */
@interface DWFacebookConnect : NSObject<FBSessionDelegate> {
    Facebook *_facebook; 
    
    __weak id<DWFacebookConnectDelegate,NSObject> _delegate;
}

/**
 * Facebook iOS SDK interface instance
 */
@property (nonatomic,strong) Facebook *facebook;

/**
 * DWFacebookConnectDelegate
 */
@property (nonatomic,weak) id<DWFacebookConnectDelegate,NSObject> delegate;


/**
 * Redirect to facebook authorization dialog
 */
- (void)authorize;

@end


/**
 * Protocol to fire events about the fbSharing lifecycle
 */
@protocol DWFacebookConnectDelegate 

@optional

- (void)fbAuthenticatedWithToken:(NSString*)accessToken;
- (void)fbAuthenticationFailed;

@end
