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
extern NSString* const kNImageDownloaded;
extern NSString* const kNImageDownloadError;
extern NSString* const kNFacebookURLOpened;
extern NSString* const kNWelcomeNavigationFinished;


/**
 * Third Party Aps
 */
extern NSString* const kFacebookAppID;

/**
 * JSON key names
 */
extern NSString* const kKeyID;
extern NSString* const kKeyCallerID;
extern NSString* const kKeyResourceID;
extern NSString* const kKeyMessage;
extern NSString* const kKeyResponse;
extern NSString* const kKeyURL;
extern NSString* const kKeyImage;
extern NSString* const kKeyError;
extern NSString* const kKeyUser;

/**
 * Misc
 */
extern NSString* const kRailsDateTimeFormat;




/**
 * Reset options for the Tab Bar 
 */
typedef enum {
    DWTabBarResetTypeNone    = -1,
    DWTabBarResetTypeHard    = 0,
    DWTabBarResetTypeSoft    = 1
} DWTabBarResetType;


/**
 * Model presenters
 */
extern NSInteger const kDefaultModelPresenter;

@interface DWConstants : NSObject
@end
