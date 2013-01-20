//
//  DWConstants.m
//  Mine
//
//  Created by Siddharth Batra on 7/20/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWConstants.h"


//----------------------------------------------------------------------------------------------------
NSString* const kVersion            = @"1.3.1";
NSString* const kGet				= @"GET";
NSString* const kPost               = @"POST";
NSString* const kPut				= @"PUT";
NSString* const kDelete				= @"DELETE";
NSString* const kAppProtocol        = @"http://";
NSString* const kClientName         = @"iphone";
NSString* const kUserAgent          = @"Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4";
NSString* const kInternalAppScheme  = @"mine-internal";
NSString* const kContactEmail       = @"contact@getmine.com";

#if ENVIRONMENT == DEVELOPMENT
NSString* const kAppServer      = @"sbat.getmine.com";
#elif ENVIRONMENT == STAGING
NSString* const kAppServer	= @"staging.getmine.com";
#elif ENVIRONMENT == PRODUCTION
NSString* const kAppServer	= @"getmine.com";
#endif


//----------------------------------------------------------------------------------------------------
NSString* const kClientSalt               = @"20988410f43fa368";
NSString* const kClientEncryptionPhrase   = @"f0837530983794e3";


//----------------------------------------------------------------------------------------------------
NSString* const kNEnteringLowMemoryState    = @"NEnteringLowMemoryState";
NSString* const kNImageDownloaded           = @"NImageDownloaded";
NSString* const kNImageDownloadError        = @"NImageDownloadError";
NSString* const kNFacebookURLOpened         = @"NFacebookURLOpened";
NSString* const kNUserLoggedIn              = @"NUserLoggedIn";
NSString* const kNUserLoggedOut             = @"NUserLoggedOut";
NSString* const kNWelcomeNavigationFinished = @"NWelcomeNavigationFinished";
NSString* const kNPaginationCellReached     = @"NPaginationCellReached";
NSString* const kNCommentAddedForPurchase   = @"NCommentAddedForPurchase";
NSString* const kNRequestTabBarIndexChange  = @"NRequestTabBarIndexChange";
NSString* const kNRequestPurchaseDelete     = @"NRequestPurchaseDelete";
NSString* const kNOnboardingStarted         = @"NOnboardingStarted";
NSString* const kNSessionRenewed            = @"NSessionRenewed";
NSString* const kNUpdateNotificationsCount  = @"NUpdateNotificationsCount";


//----------------------------------------------------------------------------------------------------
NSInteger const kColumnsInProductsSearch        = 3;
NSInteger const kColumnsInPurchaseSearch        = 2;
NSInteger const kColumnsInGlobalFeed            = 2;
NSInteger const kColumnsInUnapprovedPurchases   = 2;


//----------------------------------------------------------------------------------------------------
NSString* const kFacebookAppID                  = @"245230762190915";
NSString* const kTumblrConsumerKey              = @"89jCI6WNG1Ym9wYLkJ1FfDVTZCsMbdtJoSwPbBzSb6ueJMbo0G";
NSString* const kTumblrConsumerSecret           = @"L7BbVCPlAYq0ewzxEEEiJyIzgY8Ihj9YxALq9Ol0ueLnStNBwM";
NSString* const kTwitterOAuthConsumerKey        = @"Y8wcijb0orzZSbkd3fQ4g";
NSString* const kTwitterOAuthConsumerSecret     = @"i7Oqqpy1I1ZycqRpJOSsBMylURsFlC2Qo7pQc0YbUzk";
NSString* const kTapjoyAppID                    = @"a489fa1d-2290-4519-898e-3ff4c0b0f526";
NSString* const kTapjoyAppSecret                = @"Q2fOpUjit0WFLkGBG6w8";


//----------------------------------------------------------------------------------------------------
NSString* const kKeyID                  = @"id";
NSString* const kKeyCallerID            = @"caller_id";
NSString* const kKeyResourceID          = @"resource_id";
NSString* const kKeyMessage             = @"message";
NSString* const kKeyResponse            = @"response";
NSString* const kKeyURL                 = @"url";
NSString* const kKeyImage               = @"image";
NSString* const kKeyError               = @"error";
NSString* const kKeyUser                = @"user";
NSString* const kKeyPurchase            = @"purchase";
NSString* const kKeyFollowing           = @"following";
NSString* const kKeyFollowingCreated    = @"following_created";
NSString* const kKeyFollowingDestroyed  = @"following_destroyed";
NSString* const kKeyTabIndex            = @"tabIndex";
NSString* const kKeyResetType           = @"reset_type";
NSString* const kKeyCount               = @"count";
NSString* const kKeyCreatedAt           = @"created_at";
NSString* const kKeyImageURL            = @"image_url";
NSString* const kKeyStatus              = @"status";
NSString* const kKeyProgress            = @"progress";
NSString *const kKeyNavigationBar       = @"navigationBar";

//----------------------------------------------------------------------------------------------------
NSString* const kRailsDateTimeFormat = @"yyyy-MM-dd HH:mm:ss ZZZ";

//----------------------------------------------------------------------------------------------------
NSInteger const kFeedTabIndex       = 0;
NSInteger const kProfileTabIndex    = 1;
NSInteger const kUsersTabIndex      = 2;
NSInteger const kTabBarHeight       = 44;

//----------------------------------------------------------------------------------------------------
NSString* const kImgChevron         = @"chevron.png";
NSString* const kImgChevronWhite    = @"chevron-white.png";
NSString* const kImgDoneOff         = @"nav-btn-done-off.png";
NSString* const kImgDoneOn          = @"nav-btn-done-on.png";
NSString* const kImgMessageDrawer   = @"message-drawer-opaque.png";
NSString* const kImgTopShadow       = @"nav-shadow.png";
NSString* const kImgBottomShadow    = @"tab-shadow.png";

//----------------------------------------------------------------------------------------------------
NSInteger const kDefaultModelPresenter = 0;


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWConstants
@end
