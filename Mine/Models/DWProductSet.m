//
//  DWProductSet.m
//  Mine
//
//  Created by Deepak Rao on 7/31/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWProductSet.h"

@implementation DWProductSet

@synthesize products = _products;

//----------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	
	if(self) {  
        self.products = [NSMutableArray array];
    }
	
	return self;  
}

//----------------------------------------------------------------------------------------------------
- (void)addProduct:(DWProduct*)product {
    [self.products addObject:product];
}

//----------------------------------------------------------------------------------------------------
- (NSInteger)length {
    return [self.products count];
}

@end