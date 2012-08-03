//
//  DWModelSet.h
//  Mine
//
//  Created by Siddharth Batra on 8/03/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DWModelSet : NSObject {
    NSMutableArray *_models;
}

/**
 * Set of model objects
 */
@property (nonatomic,strong) NSMutableArray *models;

/**
 * Total models in the set.
 */ 
@property (nonatomic,readonly) NSInteger length;

/**
 * Add a model into the array.
 */
- (void)addModel:(id)model;

@end