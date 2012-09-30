//
//  DWSessionController.h
//  Mine
//
//  Created by Siddharth Batra on 9/29/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol DWSessionControllerDelegate;


@interface DWSessionController : NSObject {
    __weak id<DWSessionControllerDelegate,NSObject> _delegate;
}

@property (nonatomic,weak) id<DWSessionControllerDelegate,NSObject> delegate;

- (void)destroyForever;

@end



@protocol DWSessionControllerDelegate

@optional

- (void)sessionDestroyed;
- (void)sessionDestroyError:(NSString*)error;

@end