//
//  DWLike.m
//  Mine
//
//  Created by Siddharth Batra on 7/28/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWLike.h"

#import "DWUser.h"
#import "DWConstants.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWLike

@synthesize user = _user;


//----------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	
	if(self) {  
    }
	
	return self;  
}

//----------------------------------------------------------------------------------------------------
-(void)dealloc{
	[self freeMemory];
    
    [self.user destroy];
    
	DWDebug(@"Like released %d",self.databaseID);
}

//----------------------------------------------------------------------------------------------------
- (void)freeMemory {
}

//----------------------------------------------------------------------------------------------------
- (void)update:(NSDictionary*)like {
    [super update:like];
    
    NSDictionary *user = [like objectForKey:kKeyUser];
    
    if(user) {
        if(self.user)
            [self.user update:user];
        else
            self.user = [DWUser create:user];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)debug {
    DWDebug(@"%d",self.databaseID);
    [self.user debug];
}

@end
