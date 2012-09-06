//
//  DWConstants.m
//  Mine
//
//  Created by Siddharth Batra on 7/20/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWConstants.h"


//----------------------------------------------------------------------------------------------------
NSString* const kVersion            = @"1.0.0";
NSString* const kGet				= @"GET";
NSString* const kPost               = @"POST";
NSString* const kPut				= @"PUT";
NSString* const kDelete				= @"DELETE";
NSString* const kAppProtocol        = @"http://";
NSString* const kClientName         = @"iphone";
NSString* const kUserAgent          = @"Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4";

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
NSString* const kNWelcomeNavigationFinished = @"NWelcomeNavigationFinished";
NSString* const kNPaginationCellReached     = @"NPaginationCellReached";
NSString* const kNCommentAddedForPurchase   = @"NCommentAddedForPurchase";

//----------------------------------------------------------------------------------------------------
NSString* const kMsgActionSheetCancel           = @"Cancel";
NSString* const kMsgActionSheetDelete           = @"Delete";


//----------------------------------------------------------------------------------------------------
NSInteger const kColumnsInProductsSearch        = 3;
NSInteger const kColumnsInPurchaseSearch        = 2;

//----------------------------------------------------------------------------------------------------
NSString* const kFacebookAppID                  = @"245230762190915";
NSString* const kTumblrConsumerKey              = @"89jCI6WNG1Ym9wYLkJ1FfDVTZCsMbdtJoSwPbBzSb6ueJMbo0G";
NSString* const kTumblrConsumerSecret           = @"L7BbVCPlAYq0ewzxEEEiJyIzgY8Ihj9YxALq9Ol0ueLnStNBwM";
NSString* const kTwitterOAuthConsumerKey        = @"Y8wcijb0orzZSbkd3fQ4g";
NSString* const kTwitterOAuthConsumerSecret     = @"i7Oqqpy1I1ZycqRpJOSsBMylURsFlC2Qo7pQc0YbUzk";


//----------------------------------------------------------------------------------------------------
NSString* const kKeyID          = @"id";
NSString* const kKeyCallerID    = @"caller_id";
NSString* const kKeyResourceID  = @"resource_id";
NSString* const kKeyMessage     = @"message";
NSString* const kKeyResponse    = @"response";
NSString* const kKeyURL         = @"url";
NSString* const kKeyImage       = @"image";
NSString* const kKeyError       = @"error";
NSString* const kKeyUser        = @"user";
NSString* const kKeyPurchase    = @"purchase";

//----------------------------------------------------------------------------------------------------
NSString* const kRailsDateTimeFormat = @"yyyy-MM-dd HH:mm:ss ZZZ";

//----------------------------------------------------------------------------------------------------
NSString* const kNavBarMineLogo = @"nav-mine-logo.png";

//----------------------------------------------------------------------------------------------------
NSInteger const kDefaultModelPresenter = 0;


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWConstants
@end
