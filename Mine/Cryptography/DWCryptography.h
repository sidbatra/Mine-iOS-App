//
//  DWCryptography.h
//  Mine
//
//  Created by Siddharth Batra on 7/21/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Static methods to help with cryptography and obfuscation
 */
@interface DWCryptography : NSObject

/**
 * Convert an NSInteger to an NSString in any base.
 */
+ (NSString*)num2str:(NSInteger)val 
                base:(int)base;

/**
 * Obfuscate the given integer and convert to a different base while still 
 * keeping it recoverable
 * Ref - http://blog.michaelgreenly.com/2008/01/obsificating-ids-in-urls.html
 * Ref - http://en.wikipedia.org/wiki/Modular_multiplicative_inverse
 */
+ (NSString*)obfuscate:(NSInteger)val;

/**
 * Convert given string to an MD5 hash.
 */
+ (NSString *)MD5:(NSString*)string;

@end
