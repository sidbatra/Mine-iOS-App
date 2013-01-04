//
//  DWFacebookConnect.h
//  Mine
//
//  Created by Deepak Rao on 7/23/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol DWFacebookConnectDelegate;

/**
 * Wrapper over the Facebook iOS SDK
 */
@interface DWFacebookConnect : NSObject {    
    __weak id<DWFacebookConnectDelegate,NSObject> _delegate;
}

@property (nonatomic,weak) id<DWFacebookConnectDelegate,NSObject> delegate;

- (void)authorizeRead;
- (void)authorizeWrite;

@end



@protocol DWFacebookConnectDelegate 

@optional

- (void)fbReadAuthenticatedWithToken:(NSString*)accessToken;
- (void)fbWriteAuthenticatedWithToken:(NSString*)accessToken;
- (void)fbAuthenticationFailed;

@end
