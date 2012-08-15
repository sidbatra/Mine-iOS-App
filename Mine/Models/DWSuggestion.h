//
//  DWSuggestion.h
//  Mine
//
//  Created by Deepak Rao on 8/14/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWPoolObject.h"

/**
 *
 */
extern NSString* const kKeyImageURL;
extern NSString* const kKeySmallImageURL;

extern NSString* const kNImgSuggestionLoaded;
extern NSString* const kNImgSuggestionLoadError;
extern NSString* const kNImgSuggestionSmallLoaded;
extern NSString* const kNImgSuggestionSmallLoadError;


/**
 * Representation of the Suggestion model mounted on the MemoryPool.
 */
@interface DWSuggestion : DWPoolObject {
    NSString    *_title;
    NSString    *_shortTitle;
    NSString    *_example;
    NSString    *_thing;
    
    NSString    *_imageURL;
    NSString    *_smallImageURL;
}

/**
 * Title
 */
@property (nonatomic,copy) NSString* title;

/**
 * Short title
 */
@property (nonatomic,copy) NSString* shortTitle;

/**
 * Example
 */
@property (nonatomic,copy) NSString* example;

/**
 * Type of object that the suggestion represents
 */
@property (nonatomic,copy) NSString* thing;

/**
 * URL for the placeholder image.
 */
@property (nonatomic,copy) NSString *imageURL;

/**
 * URL for the thumbnail placeholder image.
 */
@property (nonatomic,copy) NSString *smallImageURL;

/**
 * Returns the original UIImage if it has been downloaded or nil.
 */
@property (nonatomic,readonly) UIImage *image;

/**
 * Returns the small UIImage if it has been downloaded or nil
 */
@property (nonatomic,readonly) UIImage *smallImage;


/**
 * Start downloading the original image
 */
- (void)downloadImage;

/**
 * Start downloading the small sized image
 */
- (void)downloadSmallImage;

/**
 * Prints out key fields for debugging.
 */
- (void)debug;

@end
