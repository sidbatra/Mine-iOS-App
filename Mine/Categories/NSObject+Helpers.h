//
//  NSObject+Helpers.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Extension of NSObject for adding custom helpers
 */
@interface NSObject(DWHelpers) 

/**
 * Returns the class name as a string
 */
- (NSString*)className;


/**
 * Returns the class name as a string
 */
+ (NSString*)className;

@end
