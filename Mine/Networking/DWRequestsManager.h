//
//  DWRequestsManager.h
//  Copyright 2011 Denwen. All rights reserved.
//	

#import <Foundation/Foundation.h>

/**
 * DWRequestsManager enables absracted access to all network operations
 * via a simple interface
 */
@interface DWRequestsManager : NSObject {

}

/**
 * Shared sole instance of the class
 */
+ (DWRequestsManager *)sharedDWRequestsManager;


/**
 * Create a post request to be sent to the app server. The post params are sent
 * via the request body and not the URL to accomodate large and or several params.
 */
- (NSInteger)createPostBodyBasedAppRequest:(NSString*)localRequestURL
                                withParams:(NSDictionary*)params
                       successNotification:(NSString*)successNotification
                         errorNotification:(NSString*)errorNotification
                              authenticate:(NSInteger)authenticate;

/**
 * Create a request to be sent to the app server.
 * resourceID is bundled with the success/error notification for identification
 * authentcate indicates the need for current user authentication.
 * caller id is a unique for the calling object.
 */
- (NSInteger)createAppRequest:(NSString*)localRequestURL 
          successNotification:(NSString*)successNotification
            errorNotification:(NSString*)errorNotification
                requestMethod:(NSString*)requestMethod
                 authenticate:(NSInteger)authenticate
                   resourceID:(NSInteger)resourceID
                     callerID:(NSUInteger)callerID;

/**
 * Overloaded method for createAppRequest. 
 */
- (NSInteger)createAppRequest:(NSString*)localRequestURL 
          successNotification:(NSString*)successNotification
            errorNotification:(NSString*)errorNotification
                requestMethod:(NSString*)requestMethod
                 authenticate:(BOOL)authenticate;

/**
 * Overloaded method for createAppRequest. 
 */
- (NSInteger)createAppRequest:(NSString*)localRequestURL 
          successNotification:(NSString*)successNotification
            errorNotification:(NSString*)errorNotification
                requestMethod:(NSString*)requestMethod
                 authenticate:(BOOL)authenticate
                     callerID:(NSUInteger)callerID;

/**
 * Overloaded method for createAppRequest. 
 */
- (NSInteger)createAppRequest:(NSString*)localRequestURL 
          successNotification:(NSString*)successNotification
            errorNotification:(NSString*)errorNotification
                requestMethod:(NSString*)requestMethod
                 authenticate:(BOOL)authenticate
                   resourceID:(NSInteger)resourceID;

/**
 * Download the image from the given URL and fire the given
 * notifications
 */
- (NSInteger)getImageAt:(NSString*)url 
         withResourceID:(NSInteger)resourceID
    successNotification:(NSString*)theSuccessNotification
      errorNotification:(NSString*)theErrorNotification;


@end

