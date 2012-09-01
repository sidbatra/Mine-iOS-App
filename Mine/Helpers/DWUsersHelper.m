//
//  DWUsersHelper.m
//  Mine
//
//  Created by Siddharth Batra on 9/1/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWUsersHelper.h"

#import "DWUser.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUsersHelper

//----------------------------------------------------------------------------------------------------
+ (NSString*)genderPronounForUser:(DWUser*)user {
    return user.gender ? ([user.gender isEqualToString:@"male"] ? @"his" : @"her") : @"their";
}

@end
