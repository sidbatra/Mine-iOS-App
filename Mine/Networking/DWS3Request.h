//
//  DWS3Request.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWRequest.h"

/**
 * Handles streaming uploads to the S3 server
 */
@interface DWS3Request : DWRequest {
	NSString		*_filename;
}


/**
 * Filename of uploaded file
 */
@property (nonatomic) NSString *filename;


/**
 * Use the requestWithRequestURL method in the parent class
 * and setup custom properties for uploading an image
 */
+ (id)requestNewImage:(UIImage*)image
           withPrefix:(NSString*)prefix;

/**
 * Use the requestWithRequestURL method in the parent class
 * and setup custom properties for uploading a video
 */
+ (id)requestNewVideo:(NSURL*)theURL
		atOrientation:(NSString*)orientation
           withPrefix:(NSString*)prefix;

@end
