//
//  DWNotificationManager.m
//  Mine
//
//  Created by Siddharth Batra on 8/8/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWNotificationManager.h"

#import "SynthesizeSingleton.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWNotificationManager

SYNTHESIZE_SINGLETON_FOR_CLASS(DWNotificationManager);

//----------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	
	if(self) {
	}
	
	return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {	
}

//----------------------------------------------------------------------------------------------------
- (void)updateDeviceToken:(NSData*)deviceToken {
    NSString* token = [NSString stringWithFormat:@"%@",deviceToken];
    NSLog(@"TOKEN - %@",[[token substringWithRange:NSMakeRange(1, [token length]-2)] stringByReplacingOccurrencesOfString:@" " withString:@""]);
}

@end
