//
//  DWProduct.h
//  Mine
//
//  Created by Deepak Rao on 7/30/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWPoolObject.h"

/**
 * 
 */
extern NSString* const kKeyMediumImageURL;
extern NSString* const kKeyLargeImageURL;
extern NSString* const kNImgProductMediumLoaded;
extern NSString* const kNImgProductMediumLoadError;
extern NSString* const kNImgProductLargeLoaded;
extern NSString* const kNImgProductLargeLoadError;



/**
 * Representation of the Product model 
 */
@interface DWProduct : DWPoolObject {
    NSString        *_uniqueID;
    NSString        *_title;
    
    NSString        *_mediumImageURL;
    NSString        *_largeImageURL;
    NSString        *_sourceURL;
}

/**
 * Unique identifier.
 */
@property (nonatomic,copy) NSString *uniqueID;

/**
 * Title
 */
@property (nonatomic,copy) NSString *title;

/**
 * URL for a medium sized product image.
 */
@property (nonatomic,copy) NSString *mediumImageURL;

/**
 * URL for a large sized product image.
 */
@property (nonatomic,copy) NSString *largeImageURL;

/**
 * URL for the source of the product.
 */
@property (nonatomic,copy) NSString *sourceURL;

/**
 * Returns the medium UIImage if it has been downloaded or nil.
 */
@property (nonatomic,readonly) UIImage *mediumImage;

/**
 * Returns the large UIImage if it has been downloaded or nil
 */
@property (nonatomic,readonly) UIImage *largeImage;


/**
 * Start downloading the medium sized image
 */
- (void)downloadMediumImage;

/**
 * Start downloading the large sized image
 */
- (void)downloadLargeImage;

/**
 * Prints out key fields for debugging.
 */
- (void)debug;

@end
