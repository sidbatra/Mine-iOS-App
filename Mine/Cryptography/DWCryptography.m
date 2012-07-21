//
//  DWCryptography.m
//  Mine
//
//  Created by Siddharth Batra on 7/21/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWCryptography.h"

#import <CommonCrypto/CommonDigest.h>


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWCryptography

//----------------------------------------------------------------------------------------------------
+ (NSString*)num2str:(NSInteger)val 
                base:(int)base {
    
    static const char ruby_digitmap[] = "0123456789abcdefghijklmnopqrstuvwxyz";
    char buf[sizeof(NSInteger) *CHAR_BIT + 2], *b = buf + sizeof buf;
    int neg = 0;
    
    if (val == 0 || base < 2 || 36 < base) {
        return @"0";
    }
    if (val < 0) {
        val = -val;
        neg = 1;
    }
    *--b = '\0';
    do {
        *--b = ruby_digitmap[(int)(val % base)];
    } while (val /= base);
    if (neg) {
        *--b = '-';
    }
    
    return [NSString stringWithUTF8String:b];
}

//----------------------------------------------------------------------------------------------------
+ (NSString*)obfuscate:(NSInteger)val {
    return [self num2str:(val * 9576890767 & 2147483647) base:36];
}

//----------------------------------------------------------------------------------------------------
+ (NSString *)MD5:(NSString*)string {
    const char *cstr = [string UTF8String];
    unsigned char result[16];
    CC_MD5(cstr, strlen(cstr), result);
    
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3], 
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];  
}

@end
