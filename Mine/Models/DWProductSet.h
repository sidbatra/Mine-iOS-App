//
//  DWProductSet.h
//  Mine
//
//  Created by Deepak Rao on 7/31/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWProduct.h"

@interface DWProductSet : NSObject {
    NSMutableArray *_products;
}

/**
 * Set of products
 */
@property (nonatomic,strong) NSMutableArray *products;

/**
 * Add a product to the mutable array
 */
- (void)addProduct:(DWProduct*)product;

/**
 * Number of products in the set
 */
- (NSInteger)length;

@end