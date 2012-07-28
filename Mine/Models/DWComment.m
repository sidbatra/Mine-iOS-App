//
//  DWComment.m
//  Mine
//
//  Created by Siddharth Batra on 7/28/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWComment.h"

#import "DWUser.h"
#import "DWConstants.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWComment

@synthesize message = _message;
@synthesize user    = _user;


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
    
	NSLog(@"Comment released %d",self.databaseID);
}

//----------------------------------------------------------------------------------------------------
- (void)freeMemory {
}

//----------------------------------------------------------------------------------------------------
- (void)update:(NSDictionary*)comment {
    [super update:comment];
    
    NSString *message   = [comment objectForKey:kKeyMessage];
    NSDictionary *user  = [comment objectForKey:kKeyUser];
    
    if(message && ![self.message isEqualToString:message])
        self.message = message;
    
    if(user) {
        if(self.user)
            [self.user update:user];
        else
            self.user = [DWUser create:user];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)debug {
    NSLog(@"%@",self.message);
    [self.user debug];
}
@end
