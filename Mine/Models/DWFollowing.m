//
//  DWFollowing.m
//  Mine
//
//  Created by Siddharth Batra on 8/4/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWFollowing.h"

NSString* const kKeyUserID  = @"user_id";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWFollowing

@synthesize userID = _userID;

//----------------------------------------------------------------------------------------------------
-(void)dealloc{
    NSLog(@"Following released - %d",self.databaseID);
}

//----------------------------------------------------------------------------------------------------
- (void)update:(NSDictionary*)following {
    [super update:following];

    NSString *userID  = [following objectForKey:kKeyUserID];
    
    if(userID)
        self.userID = [userID integerValue];
}

@end