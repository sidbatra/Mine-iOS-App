//
//  DWRequestsManager.m
//  Copyright 2011 Denwen. All rights reserved.
//	

#import "DWRequestsManager.h"
#import "DWSession.h"
#import "DWConstants.h"

#import "ASIDownloadCache.h"

// Requests
#import "DWAppRequest.h"
#import "DWImageRequest.h"

#import "NSString+Helpers.h"
#import "DWCryptography.h"
#import "SynthesizeSingleton.h"



/**
 * Private method and property declarations
 */
@interface DWRequestsManager()

/**
 * Form the complete URL with or without authentication to send
 * a request to the app server
 */
- (NSString*)createAppRequestURL:(NSString*)localRequestURL 
                    authenticate:(BOOL)authenticate;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWRequestsManager

SYNTHESIZE_SINGLETON_FOR_CLASS(DWRequestsManager);

//----------------------------------------------------------------------------------------------------
- (NSString*)createAppRequestURL:(NSString*)localRequestURL 
                    authenticate:(BOOL)authenticate {
	
    NSMutableString *url = [NSMutableString stringWithFormat:@"%@%@%@",
                            kAppProtocol,
                            kAppServer,
                            localRequestURL];
    
    [url appendFormat:@"&v=%@&auth_client=%@&auth_time=%d",kVersion,kClientName,(NSInteger)[[NSDate date] timeIntervalSince1970]];
    
    if(authenticate && [[DWSession sharedDWSession] isAuthenticated])
        [url appendFormat:@"&auth_id=%@",[[DWCryptography obfuscate:[DWSession sharedDWSession].currentUser.databaseID] stringByEncodingHTMLCharacters]];
    
    [url appendFormat:@"&auth_secret=%@",[DWCryptography MD5:[NSString stringWithFormat:@"--%@--%@",kClientSalt,url]]];
                            
	return	[NSString stringWithString:url];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark App Requests

//----------------------------------------------------------------------------------------------------
- (NSInteger)createPostBodyBasedAppRequest:(NSString*)localRequestURL
                                withParams:(NSDictionary*)params
                       successNotification:(NSString*)successNotification
                         errorNotification:(NSString*)errorNotification
                              authenticate:(NSInteger)authenticate {
    
    NSString *requestURL = [self createAppRequestURL:localRequestURL
                                        authenticate:authenticate];
    
    DWAppRequest *request  = [DWAppRequest requestWithRequestURL:requestURL 
                                                   successNotification:successNotification
                                                     errorNotification:errorNotification
                                                            resourceID:0
                                                              callerID:0];
                                                        
    NSEnumerator *enumerator = [params keyEnumerator];
    id key;
    
    while ((key = [enumerator nextObject])) {
        [request addPostValue:[params objectForKey:key] 
                       forKey:key];
    }
    
    [request setDelegate:self];
	[request setRequestMethod:kPost];
    [request setShouldContinueWhenAppEntersBackground:YES];
    
	[request startAsynchronous];
    
    return request.resourceID;
}

//----------------------------------------------------------------------------------------------------
- (NSInteger)createAppRequest:(NSString*)localRequestURL 
          successNotification:(NSString*)successNotification
            errorNotification:(NSString*)errorNotification
                requestMethod:(NSString*)requestMethod
                 authenticate:(NSInteger)authenticate
                   resourceID:(NSInteger)resourceID
                     callerID:(NSUInteger)callerID {
	
	
	NSString *requestURL = [self createAppRequestURL:localRequestURL
                                        authenticate:authenticate];
    
	DWAppRequest *request = [DWAppRequest requestWithRequestURL:requestURL
                                                  successNotification:successNotification
                                                    errorNotification:errorNotification
                                                           resourceID:resourceID
                                                             callerID:callerID];
    
	[request setDelegate:self];
	[request setRequestMethod:requestMethod];
    
    if(requestMethod == kPost)
        [request setShouldContinueWhenAppEntersBackground:YES];

	[request startAsynchronous];
	
    return request.resourceID;
}

//----------------------------------------------------------------------------------------------------
- (NSInteger)createAppRequest:(NSString*)localRequestURL 
          successNotification:(NSString*)successNotification
            errorNotification:(NSString*)errorNotification
                requestMethod:(NSString*)requestMethod
                 authenticate:(BOOL)authenticate {
    
    return [self createAppRequest:localRequestURL
              successNotification:successNotification
                errorNotification:errorNotification
                    requestMethod:requestMethod
                     authenticate:authenticate
                       resourceID:0
                         callerID:0];
}

//----------------------------------------------------------------------------------------------------
- (NSInteger)createAppRequest:(NSString*)localRequestURL 
          successNotification:(NSString*)successNotification
            errorNotification:(NSString*)errorNotification
                requestMethod:(NSString*)requestMethod
                 authenticate:(BOOL)authenticate
                     callerID:(NSUInteger)callerID {
    
    return [self createAppRequest:localRequestURL
              successNotification:successNotification
                errorNotification:errorNotification
                    requestMethod:requestMethod
                     authenticate:authenticate
                       resourceID:0
                         callerID:callerID];
}

//----------------------------------------------------------------------------------------------------
- (NSInteger)createAppRequest:(NSString*)localRequestURL 
             successNotification:(NSString*)successNotification
               errorNotification:(NSString*)errorNotification
                   requestMethod:(NSString*)requestMethod
                    authenticate:(BOOL)authenticate
                      resourceID:(NSInteger)resourceID {
    
    return [self createAppRequest:localRequestURL
              successNotification:successNotification
                errorNotification:errorNotification
                    requestMethod:requestMethod
                     authenticate:authenticate
                       resourceID:resourceID
                         callerID:0];
}	


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Image Requests

//----------------------------------------------------------------------------------------------------
- (NSInteger)getImageAt:(NSString*)url 
         withResourceID:(NSInteger)resourceID
    successNotification:(NSString*)theSuccessNotification
      errorNotification:(NSString*)theErrorNotification {
	
	DWImageRequest *request = [DWImageRequest requestWithRequestURL:url 
												successNotification:theSuccessNotification
												  errorNotification:theErrorNotification
                                                         resourceID:resourceID];
	[request setDelegate:self];
	[request setRequestMethod:kGet];
	[request startAsynchronous];
    
    return request.resourceID;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark ASIHTTPRequestDelegate

//----------------------------------------------------------------------------------------------------
- (void)requestFinished:(DWRequest*)request {
	[request processResponse:[request responseString] andResponseData:[request responseData]];
}

//----------------------------------------------------------------------------------------------------
- (void)requestFailed:(DWRequest*)request {
	[request processError:[request error]];
}

/*
- (void)request:(ASIHTTPRequest *)request didSendBytes:(long long)bytes {
}


- (void)request:(ASIHTTPRequest *)request incrementUploadSizeBy:(long long)newLength {
}
*/

@end
