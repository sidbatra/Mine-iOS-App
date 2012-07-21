//
//  DWRequest.m
//  Copyright 2011 Denwen. All rights reserved.
//	

#import "DWRequest.h"

#import "JSON.h"
#import "DWConstants.h"

static NSInteger const kPersistenceTimeout	= 120;
static NSInteger const kRandomStringBase    = 100000000;



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWRequest

@synthesize resourceID				= _resourceID;
@synthesize successNotification		= _successNotification;
@synthesize errorNotification		= _errorNotification;
@synthesize callerID                = _callerID;


//----------------------------------------------------------------------------------------------------
- (id)initWithRequestURL:(NSString*)requestURL 
	 successNotification:(NSString*)theSuccessNotification
	   errorNotification:(NSString*)theErrorNotification {
	
	NSURL *tempURL = [NSURL URLWithString:requestURL];
	
	self = [super initWithURL:tempURL];
	
	if(self) {
		self.successNotification	= theSuccessNotification;
		self.errorNotification		= theErrorNotification;
		
		//[self setShouldAttemptPersistentConnection:NO];
		//[self setPersistentConnectionTimeoutSeconds:kPersistenceTimeout];
	}
	
	return self;
}

//----------------------------------------------------------------------------------------------------
- (void)generateResourceID {
	_resourceID = [[NSDate date] timeIntervalSince1970] + arc4random() % kRandomStringBase;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Templates

//----------------------------------------------------------------------------------------------------
- (void)processResponse:(NSString*)responseString andResponseData:(NSData*)responseData {}

//----------------------------------------------------------------------------------------------------
- (void)processError:(NSError*)error {}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Static

//----------------------------------------------------------------------------------------------------
+ (id)requestWithRequestURL:(NSString*)requestURL
		successNotification:(NSString*)theSuccessNotification
		  errorNotification:(NSString*)theErrorNotification 
                 resourceID:(NSInteger)theResourceID
                   callerID:(NSUInteger)theCallerID {
	
	DWRequest *request = [[self alloc] initWithRequestURL:requestURL
                                      successNotification:theSuccessNotification
                                        errorNotification:theErrorNotification];
    
    if(!theResourceID)
        [request generateResourceID];
    else 
        request.resourceID = theResourceID;
        
    request.callerID = theCallerID;
    
    return request;
}

@end
