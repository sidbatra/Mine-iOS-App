//
//  DWUnion.m
//  Mine
//
//  Created by Siddharth Batra on 9/9/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWUnion.h"
#import "DWConstants.h"

@interface DWUnion() {
    NSMutableDictionary *_extra;
}

@property (nonatomic,strong) NSMutableDictionary *extra;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUnion

@synthesize title       = _title;
@synthesize subtitle    = _subtitle;
@synthesize extra       = _extra;


//----------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	
	if(self) {
        self.extra = [[NSMutableDictionary alloc] init];
    }
	
	return self;
}

//----------------------------------------------------------------------------------------------------
- (void)setCustomKeyValue:(NSString*)key value:(id)value {
    [self.extra setObject:value
                   forKey:key];
}

//----------------------------------------------------------------------------------------------------
- (id)customValueforKey:(NSString*)key {
    return [self.extra objectForKey:key];
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    DWDebug(@"Union released");
}

@end
