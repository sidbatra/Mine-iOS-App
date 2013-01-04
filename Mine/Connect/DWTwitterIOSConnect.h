//
//  DWTwitterIOSConnect.h
//  Mine
//
//  Created by Siddharth Batra on 1/3/13.
//  Copyright (c) 2013 Denwen, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DWTwitterIOSConnectDelegate;


@interface DWTwitterIOSConnect : NSObject<UIActionSheetDelegate> {
    __weak id<DWTwitterIOSConnectDelegate> _delegate;
}

@property (nonatomic,weak) id<DWTwitterIOSConnectDelegate> delegate;

- (void)seekPermission;
- (void)startReverseAuth:(UIView*)targetView;

@end


@protocol DWTwitterIOSConnectDelegate

@required

- (void)twitterIOSPermissionGranted;
- (void)twitterIOSNoAccountsFound;
- (void)twitterIOSPermissionDenied;

@end