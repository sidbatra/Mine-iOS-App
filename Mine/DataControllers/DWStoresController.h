//
//  DWStoresController.h
//  Mine
//
//  Created by Siddharth Batra on 8/1/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DWStoresControllerDelegate;


@interface DWStoresController : NSObject

@end


@protocol DWStoresControllerDelegate

@optional

/**
 * 
 */
- (void)storesLoaded:(NSMutableArray*)array 
          withAspect:(NSString*)aspect;


@end
