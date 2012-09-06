//
//  DWFollowing.h
//  Mine
//
//  Created by Siddharth Batra on 8/4/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWPoolObject.h"


@interface DWFollowing : DWPoolObject {
     NSInteger  _userID;
}

@property (nonatomic,assign) NSInteger userID;


/**
 * Return first following in memory pool for the given user id.
 */
+ (DWFollowing*)followingForUserID:(NSInteger)userID;

@end
