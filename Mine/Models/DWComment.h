//
//  DWComment.h
//  Mine
//
//  Created by Siddharth Batra on 7/28/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWPoolObject.h"

@class DWUser;

@interface DWComment : DWPoolObject {
    NSString    *_message;
    
    DWUser      *_user;
}

/**
 * Text of the comment.
 */
@property (nonatomic,copy) NSString* message;

/**
 * The user who created the comment.
 */
@property (nonatomic,strong) DWUser *user;


/**
 * Prints out key fields for debugging.
 */
- (void)debug;

@end
