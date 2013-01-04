//
//  DWTwitterIOSConnect.h
//  Mine
//
//  Created by Siddharth Batra on 1/3/13.
//  Copyright (c) 2013 Denwen, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWUsersController.h"

@protocol DWTwitterIOSConnectDelegate;


@interface DWTwitterIOSConnect : NSObject<DWUsersControllerDelegate,UIActionSheetDelegate> {
    BOOL _updateCurrentUser;
    
    __weak id<DWTwitterIOSConnectDelegate,NSObject> _delegate;
}

@property (nonatomic,assign) BOOL updateCurrentUser;

@property (nonatomic,weak) id<DWTwitterIOSConnectDelegate,NSObject> delegate;

- (void)seekPermission;
- (void)startReverseAuth:(UIView*)targetView;

@end


@protocol DWTwitterIOSConnectDelegate

@required

- (void)twitterIOSPermissionGranted;
- (void)twitterIOSNoAccountsFound;
- (void)twitterIOSPermissionDenied;

@optional

- (void)twitterIOSSuccessfulWithToken:(NSString*)accessToken
                            andSecret:(NSString*)accessTokenSecret;

- (void)twitterIOSFailed;

- (void)twitterIOSConfigured;

@end