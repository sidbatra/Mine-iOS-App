//
//  DWImageRequest.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWImageRequest.h"

#import "ASIDownloadCache.h"
#import "DWConstants.h"

static NSInteger const kCacheTimeout = 15 * 24 * 60 * 60;


/**
 * Private declarations
 */
@interface DWImageRequest() {
    NSString *_dwImageURL;
}

/**
 * URL of the image being downloaded.
 */
@property (nonatomic,copy) NSString* dwImageURL;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWImageRequest

@synthesize dwImageURL = _dwImageURL;

//----------------------------------------------------------------------------------------------------
- (void)processResponse:(NSString*)responseString andResponseData:(NSData*)responseData {

    UIImage *image = [UIImage imageWithData:responseData];
    
    
    NSDictionary *info	= [NSDictionary dictionaryWithObjectsAndKeys:
                           self.dwImageURL     ,kKeyURL,
                           image                ,kKeyImage,
                           nil];
    
	[[NSNotificationCenter defaultCenter] postNotificationName:kNImageDownloaded
														object:nil
													  userInfo:info];
    
    
	info = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInt:self.resourceID]	,kKeyResourceID,
            image                                       ,kKeyImage,
            nil];
		
	[[NSNotificationCenter defaultCenter] postNotificationName:self.successNotification 
														object:nil
													  userInfo:info];
}

//----------------------------------------------------------------------------------------------------
- (void)processError:(NSError*)theError {

    NSDictionary *info	= [NSDictionary dictionaryWithObjectsAndKeys:
                           self.dwImageURL     ,kKeyURL,
                           nil];
    
	[[NSNotificationCenter defaultCenter] postNotificationName:kNImageDownloadError
														object:nil
													  userInfo:info];
    
    
	info = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInt:self.resourceID]		,kKeyResourceID,
            theError										,kKeyError,
            nil];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:self.errorNotification
														object:nil
													  userInfo:info];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Static

//----------------------------------------------------------------------------------------------------
+ (id)requestWithRequestURL:(NSString*)requestURL 
		successNotification:(NSString*)theSuccessNotification
		  errorNotification:(NSString*)theErrorNotification
				 resourceID:(NSInteger)theResourceID {
	
	DWImageRequest *imageRequest = [super requestWithRequestURL:requestURL
											successNotification:theSuccessNotification
											  errorNotification:theErrorNotification
													 resourceID:theResourceID
                                                       callerID:0];
	
    imageRequest.dwImageURL = requestURL;
    
    
	[imageRequest setDownloadCache:[ASIDownloadCache sharedCache]];
	[imageRequest setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
	[imageRequest setSecondsToCache:kCacheTimeout];
	
	return imageRequest;
}

@end
