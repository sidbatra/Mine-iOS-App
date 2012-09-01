//
//  DWUsersHelper.h
//  Mine
//
//  Created by Siddharth Batra on 9/1/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DWUser;

@interface DWUsersHelper : NSObject

/**
 * Gender specific pronoun for the given user. his,her, their.
 */
+ (NSString*)genderPronounForUser:(DWUser*)user;

@end
