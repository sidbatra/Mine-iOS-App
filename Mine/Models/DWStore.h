//
//  DWStore.h
//  Mine
//
//  Created by Siddharth Batra on 7/21/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWPoolObject.h"


/**
 * Representation of the Store model mounted on the MemoryPool.
 */
@interface DWStore : DWPoolObject {
    NSString    *_name;
    NSString    *_domain;
}

/**
 * Name of the store.
 */
@property (nonatomic,copy) NSString* name;

/**
 * Domain of the store website.
 */
@property (nonatomic,copy) NSString* domain;


/**
 * Prints out key fields for debugging.
 */
- (void)debug;

@end
