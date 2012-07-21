//
//  NSString+Helpers.h
//  Copyright 2011 Denwen. All rights reserved.
//
#import <CommonCrypto/CommonDigest.h>

#import "NSString+Helpers.h"


static NSString* const kAlphanumericLetters     = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
static NSInteger const kRandomStringMinLength   = 7;
static NSInteger const kRandomStringMaxLength   = 10;



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation NSString (Helpers)

- (NSString*)stringByEncodingHTMLCharacters {
	
	NSMutableString *escaped = [NSMutableString stringWithString:
								[self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSInteger length = [escaped length];
	
	[escaped replaceOccurrencesOfString:@"&" withString:@"%26" options:NSCaseInsensitiveSearch range:NSMakeRange(0, length)];
	[escaped replaceOccurrencesOfString:@"+" withString:@"%2B" options:NSCaseInsensitiveSearch range:NSMakeRange(0, length)];
	[escaped replaceOccurrencesOfString:@"," withString:@"%2C" options:NSCaseInsensitiveSearch range:NSMakeRange(0, length)];
	[escaped replaceOccurrencesOfString:@"/" withString:@"%2F" options:NSCaseInsensitiveSearch range:NSMakeRange(0, length)];
	[escaped replaceOccurrencesOfString:@":" withString:@"%3A" options:NSCaseInsensitiveSearch range:NSMakeRange(0, length)];
	[escaped replaceOccurrencesOfString:@";" withString:@"%3B" options:NSCaseInsensitiveSearch range:NSMakeRange(0, length)];
	[escaped replaceOccurrencesOfString:@"=" withString:@"%3D" options:NSCaseInsensitiveSearch range:NSMakeRange(0, length)];
	[escaped replaceOccurrencesOfString:@"?" withString:@"%3F" options:NSCaseInsensitiveSearch range:NSMakeRange(0, length)];
	[escaped replaceOccurrencesOfString:@"@" withString:@"%40" options:NSCaseInsensitiveSearch range:NSMakeRange(0, length)];
	[escaped replaceOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:NSMakeRange(0, length)];
	[escaped replaceOccurrencesOfString:@"\t" withString:@"%09" options:NSCaseInsensitiveSearch range:NSMakeRange(0, length)];
	[escaped replaceOccurrencesOfString:@"#" withString:@"%23" options:NSCaseInsensitiveSearch range:NSMakeRange(0, length)];
	[escaped replaceOccurrencesOfString:@"<" withString:@"%3C" options:NSCaseInsensitiveSearch range:NSMakeRange(0, length)];
	[escaped replaceOccurrencesOfString:@">" withString:@"%3E" options:NSCaseInsensitiveSearch range:NSMakeRange(0, length)];
	[escaped replaceOccurrencesOfString:@"\"" withString:@"%22" options:NSCaseInsensitiveSearch range:NSMakeRange(0, length)];
	[escaped replaceOccurrencesOfString:@"\n" withString:@"%0A" options:NSCaseInsensitiveSearch range:NSMakeRange(0, length)];
	
	return [NSString stringWithString:escaped];
}

//----------------------------------------------------------------------------------------------------
-(NSString*)encrypt:(NSString*)phrase {
    
	NSData *key			= [NSData dataWithBytes:[[phrase sha256] bytes] 
										 length:kCCKeySizeAES128];
	NSData *cipher		= [[self dataUsingEncoding:NSUTF8StringEncoding] aesEncryptedDataWithKey:key];
	
	return [NSString stringWithString:[cipher base64Encoding]];
}

//----------------------------------------------------------------------------------------------------
- (NSData*)sha256 {
    unsigned char *buffer;
	
    if ( ! ( buffer = (unsigned char *) malloc( CC_SHA256_DIGEST_LENGTH ) ) ) return nil;
	
    CC_SHA256( [self UTF8String], [self lengthOfBytesUsingEncoding: NSUTF8StringEncoding], buffer );
	
    return [NSData dataWithBytesNoCopy: buffer length: CC_SHA256_DIGEST_LENGTH];
}


- (NSString *)MD5String {
const char *cstr = [self UTF8String];
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

//----------------------------------------------------------------------------------------------------
+ (NSString*)randomString {
    NSInteger length = (arc4random() % (kRandomStringMaxLength - kRandomStringMinLength)) + kRandomStringMinLength;
    
    return [self stringWithRandomnessOfLength:length];
}

//----------------------------------------------------------------------------------------------------
+ (NSString*)stringWithRandomnessOfLength:(NSInteger)length {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    
    for(int i = 0; i < length; i++) 
        [randomString appendFormat: @"%c", [kAlphanumericLetters characterAtIndex:rand()%[kAlphanumericLetters length]]];
    
    return randomString;
}

@end
