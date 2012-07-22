//
//  DWImageManager.h
//  Mine
//
//  Created by Siddharth Batra on 7/21/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Abstract functionaility for downloading and storing images.
 */
@interface DWImageManager : NSObject {
}

/**
 * The sole shared instance of the class
 */
+ (DWImageManager *)sharedDWImageManager;


/**
 * Download image at the given URL and fire success & error notifications
 * accordingly. This method ensures that an image download is NOT initiated
 * if the image has already been downloaded or is being downloaded.
 */
- (void)downloadImageAtURL:(NSString*)url 
            withResourceID:(NSInteger)resourceID
       successNotification:(NSString*)successNotification
         errorNotification:(NSString*)errorNotification;

/**
 * Fetch image at the given URL if it's in the local memory pool. Returns nil
 * if the image is downloading or not present.
 */
- (id)fetch:(NSString*)url;

/**
 * Remove image from the pool.
 */
- (void)remove:(NSString*)url;

@end
