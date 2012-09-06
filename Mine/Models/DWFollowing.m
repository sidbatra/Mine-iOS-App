//
//  DWFollowing.m
//  Mine
//
//  Created by Siddharth Batra on 8/4/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWFollowing.h"
#import "DWMemoryPool.h"
#import "NSObject+Helpers.h"

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


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Static methods

//----------------------------------------------------------------------------------------------------
+ (DWFollowing*)followingForUserID:(NSInteger)userID {
    
    NSMutableDictionary *followings = [[DWMemoryPool sharedDWMemoryPool] poolForClass:[DWFollowing className]];
    DWFollowing *result = nil;
    
    for(DWFollowing *following in [followings allValues]) {
        if(following.userID == userID) {
            result = following;
            break;
        }
    }
    
    return result;
}

@end