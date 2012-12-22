//
//  DWHotmailController.h
//  Mine
//
//  Created by Siddharth Batra on 12/21/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DWHotmailControllerDelegate;


@interface DWHotmailController : NSObject {
    __weak id<DWHotmailControllerDelegate,NSObject> _delegate;
}

@property (nonatomic,weak) id<DWHotmailControllerDelegate,NSObject> delegate;


- (void)validateEmail:(NSString*)email
          andPassword:(NSString*)password;

@end


@protocol DWHotmailControllerDelegate<NSObject>

@required

- (void)hotmailValidationLoaded:(NSNumber*)status;
- (void)hotmailValidationLoadError:(NSString*)error;

@end