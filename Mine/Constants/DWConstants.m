//
//  DWConstants.m
//  Mine
//
//  Created by Siddharth Batra on 7/20/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#define DEVELOPMENT 0
#define STAGING     1
#define PRODUCTION  2

#define ENVIRONMENT DEVELOPMENT


#import "DWConstants.h"


//----------------------------------------------------------------------------------------------------
NSString* const kVersion            = @"1.0";
NSString* const kGet				= @"GET";
NSString* const kPost               = @"POST";
NSString* const kPut				= @"PUT";
NSString* const kDelete				= @"DELETE";
NSString* const kAppProtocol        = @"http://";
NSString* const kClientName         = @"iphone";

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
NSString* const kNWelcomeNavigationFinished = @"NWelcomeNavigationFinished";
NSString* const kNPaginationCellReached     = @"NPaginationCellReached";


//----------------------------------------------------------------------------------------------------
NSString* const kMsgActionSheetCancel           = @"Cancel";
NSString* const kMsgActionSheetDelete           = @"Delete";


//----------------------------------------------------------------------------------------------------
NSString* const kFacebookAppID  = @"245230762190915";


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

//----------------------------------------------------------------------------------------------------
NSString* const kRailsDateTimeFormat = @"yyyy-MM-dd'T'HH:mm:ss'-07:00'";

//----------------------------------------------------------------------------------------------------
NSInteger const kDefaultModelPresenter = 0;


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWConstants
@end
