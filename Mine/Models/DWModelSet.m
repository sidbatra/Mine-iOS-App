//
//  DWProductSet.m
//  Mine
//
//  Created by Deepak Rao on 7/31/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWModelSet.h"

@implementation DWModelSet

@synthesize models = _models;

//----------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	
	if(self) {  
        self.models = [NSMutableArray array];
    }
	
	return self;  
}

//----------------------------------------------------------------------------------------------------
- (void)addModel:(id)model {
    [self.models addObject:model];
}

//----------------------------------------------------------------------------------------------------
- (NSInteger)length {
    return [self.models count];
}

@end