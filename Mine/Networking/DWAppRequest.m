//
//  DWAppRequest.m
//  Copyright 2011 Denwen. All rights reserved.
//	

#import "DWAppRequest.h"

#import "JSON.h"
#import "DWConstants.h"


static NSString* const kDWErrorDomain		= @"DWError";
static NSString* const kMsgNoConnectivity   = @"No internet connection.";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWAppRequest

//----------------------------------------------------------------------------------------------------
- (void)processResponse:(NSString*)responseString andResponseData:(NSData*)responseData {
    
    NSDictionary *response      = [responseString JSONValue];
    NSDictionary *errorInfo     = [response objectForKey:kKeyError];
    
    
    if(!response) {
        [self processError:[NSError errorWithDomain:kDWErrorDomain
                                               code:-1
                                           userInfo:[NSDictionary dictionaryWithObject:kMsgNoConnectivity
                                                                                forKey:NSLocalizedDescriptionKey]]];
    }
    else if(errorInfo) {
        [self processError:[NSError errorWithDomain:kDWErrorDomain
                                               code:-1
                                           userInfo:[NSDictionary dictionaryWithObject:[errorInfo objectForKey:kKeyMessage] 
                                                                                forKey:NSLocalizedDescriptionKey]]];
    }
    else {
        NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:self.resourceID]	,kKeyResourceID,
                              [NSNumber numberWithInt:self.callerID]    ,kKeyCallerID,
                              response                                  ,kKeyResponse,
                              nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:self.successNotification 
                                                            object:nil
                                                          userInfo:info];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)processError:(NSError*)theError {
	
	NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
								[NSNumber numberWithInt:self.resourceID]	,kKeyResourceID,
                                [NSNumber numberWithInt:self.callerID]      ,kKeyCallerID,
								theError									,kKeyError,
								nil];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:self.errorNotification
														object:nil
													  userInfo:info];
}

@end
