//
//  DWConstants.h
//  Mine
//
//  Created by Siddharth Batra on 7/20/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


#define DEVELOPMENT 0
#define STAGING     1
#define PRODUCTION  2

#define ENVIRONMENT DEVELOPMENT


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
extern NSString* const kUserAgent;

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
extern NSString* const kNUserLoggedIn;
extern NSString* const kNWelcomeNavigationFinished;
extern NSString* const kNPaginationCellReached;
extern NSString* const kNCommentAddedForPurchase;



/**
 * Action sheet button text
 */
extern NSString* const kMsgActionSheetCancel;
extern NSString* const kMsgActionSheetDelete;

/**
 * Grid view related constants
 */
extern NSInteger const kColumnsInProductsSearch;
extern NSInteger const kColumnsInPurchaseSearch;


/**
 * Third Party Aps
 */
extern NSString* const kFacebookAppID;
extern NSString* const kTumblrConsumerKey;
extern NSString* const kTumblrConsumerSecret;
extern NSString* const kTwitterOAuthConsumerKey;
extern NSString* const kTwitterOAuthConsumerSecret;

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
extern NSString* const kKeyPurchase;
extern NSString* const kKeyFollowing;
extern NSString* const kKeyFollowingCreated;
extern NSString* const kKeyFollowingDestroyed;

/**
 * Misc
 */
extern NSString* const kRailsDateTimeFormat;

/**
 * UI Related
 */
extern NSString* const kNavBarMineLogo;
extern NSString* const kImgChevron;
extern NSString* const kImgDoneOff;
extern NSString* const kImgDoneOn;
extern NSString* const kImgMessageDrawer;
extern NSString* const kImgTopShadow;


/**
 * Reset options for the Tab Bar 
 */
typedef enum {
    DWTabBarResetTypeNone    = -1,
    DWTabBarResetTypeHard    = 0,
    DWTabBarResetTypeSoft    = 1
} DWTabBarResetType;


/**
 * Invite Platforms
 */
typedef enum {
    DWInvitePlatformFacebook    = 0,
    DWInvitePlatformEmail       = 1
} DWInvitePlatform;


/**
 * States for an item in the background queue
 */
typedef enum  {
    DWBackgroundQueueItemStateWaiting       = 0,
    DWBackgroundQueueItemStateInProgress    = 1,
    DWBackgroundQueueItemStateDone          = 2,
    DWBackgroundQueueItemStateFailed        = -1
}DWBackgroundQueueItemState;

/**
 * Model presenters
 */
extern NSInteger const kDefaultModelPresenter;

/**
 * Presentation styles for different models
 * Default presentation style for all model presenters
 */
enum {
    kPresentationStyleDefault   = 0,
};

/**
 * Presentation styles for the contacts presenter
 */
typedef enum {
    kContactPresenterStyleSelected = 1
} DWContactPresenterStyle;


typedef enum {
    kPurchaseFeedPresenterStyleDisabled = 1
} DWPurchaseFeedPresenterStyle;

@interface DWConstants : NSObject
@end
