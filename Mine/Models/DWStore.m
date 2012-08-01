//
//  DWStore.m
//  Mine
//
//  Created by Siddharth Batra on 7/21/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWStore.h"


static NSString* const kKeyName     = @"name";
static NSString* const kKeyDomain   = @"domain";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWStore

@synthesize name     = _name;
@synthesize domain   = _domain;


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
    
	NSLog(@"Store released %d",self.databaseID);
}

//----------------------------------------------------------------------------------------------------
- (void)freeMemory {
}

//----------------------------------------------------------------------------------------------------
- (void)update:(NSDictionary*)store {
    [super update:store];
	
    NSString *name      = [store objectForKey:kKeyName];
    NSString *domain    = [store objectForKey:kKeyDomain];

    if(name && ![self.name isEqualToString:name])
        self.name = name;
        
    if(domain && ![domain isKindOfClass:[NSNull class]] && ![self.domain isEqualToString:domain])
        self.domain = domain;
}

//----------------------------------------------------------------------------------------------------
- (void)debug {
    NSLog(@"%@ %@",self.name,self.domain);
}
@end
