//
//  DWConstants.h
//  Mine
//
//  Created by Siddharth Batra on 7/20/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Request related
 */
extern NSString* const kVersion;
extern NSString* const kGet;
extern NSString* const kPost;
extern NSString* const kPut;
extern NSString* const kDelete;
extern NSString* const kAppProtocol;
extern NSString* const kAppServer;
extern NSString* const kClientName;

/**
 * Encryption related
 */
extern NSString* const kClientSalt;
extern NSString* const kClientEncryptionPhrase;

/**
 * Notifications
 */
extern NSString* const kNEnteringLowMemoryState;


/**
 * JSON key names
 */
extern NSString* const kKeyID;
extern NSString* const kKeyCallerID;
extern NSString* const kKeyResourceID;
extern NSString* const kKeyMessage;
extern NSString* const kKeyData;
extern NSString* const kKeyImage;
extern NSString* const kKeyError;



@interface DWConstants : NSObject
@end
