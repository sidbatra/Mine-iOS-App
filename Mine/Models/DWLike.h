//
//  DWLike.h
//  Mine
//
//  Created by Siddharth Batra on 7/28/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWPoolObject.h"

@class DWUser;

@interface DWLike : DWPoolObject {
    DWUser      *_user;
}

/**
 * The user who created the like.
 */
@property (nonatomic,strong) DWUser *user;


/**
 * Prints out key fields for debugging.
 */
- (void)debug;

@end
