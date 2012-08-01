//
//  DWUser.h
//  Mine
//
//  Created by Siddharth Batra on 7/20/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWPoolObject.h"


/**
 * 
 */
extern NSString* const kKeySquareImageURL;
extern NSString* const kNImgUserSquareLoaded;
extern NSString* const kNImgUserSquareLoadError;
extern NSString* const kNImgUserLargeLoaded;
extern NSString* const kNImgUserLargeLoadError;

/**
 * Representation of the User model mounted on the MemoryPool
 */
@interface DWUser : DWPoolObject<NSCoding>  {
	NSString        *_firstName;
	NSString        *_lastName;
    NSString        *_gender;
    NSString        *_handle;
    NSString        *_byline;
    
    NSString        *_tumblrAccessToken;
    NSString        *_tumblrAccessTokenSecret;
    
    NSString        *_squareImageURL;
    NSString        *_largeImageURL;
    
    NSInteger       _purchasesCount;
}

/**
 * First name of the user
 */
@property (nonatomic,copy) NSString *firstName;

/**
 * Last name of the user
 */
@property (nonatomic,copy) NSString *lastName;

/**
 * Full name of the user.
 */
@property (nonatomic,readonly) NSString *fullName;

/**
 * Gender - male, female or nil
 */
@property (nonatomic,copy) NSString *gender;

/**
 * Handle for the user's page on the site.
 */
@property (nonatomic,copy) NSString *handle;

/**
 * Byline
 */
@property (nonatomic,copy) NSString *byline;

/**
 * Tumblr Access Token
 */
@property (nonatomic,copy) NSString *tumblrAccessToken;

/**
 * Tumblr Access Token Secret
 */
@property (nonatomic,copy) NSString *tumblrAccessTokenSecret;

/**
 * Image URL for a square user image.
 */
@property (nonatomic,copy) NSString *squareImageURL;

/**
 * Image URL for a large rectangle user image.
 */
@property (nonatomic,copy) NSString *largeImageURL;

/**
 * Returns the square UIImage if it has been downloaded or nil.
 */
@property (nonatomic,readonly) UIImage *squareImage;

/**
 * Returns the large UIImage if it has been downloaded or nil
 */
@property (nonatomic,readonly) UIImage *largeImage;

/**
 * Total purchases added.
 */
@property (nonatomic,assign) NSInteger purchasesCount;


/**
 * Start downloading the square image
 */
- (void)downloadSquareImage;

/**
 * Start downloading the large image
 */
- (void)downloadLargeImage;

/**
 * Prints out key fields for debugging.
 */
- (void)debug;

@end
