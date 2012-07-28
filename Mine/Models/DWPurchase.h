//
//  DWPurchase.h
//  Mine
//
//  Created by Siddharth Batra on 7/21/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWPoolObject.h"

@class DWUser;
@class DWStore;


/**
 * 
 */
extern NSString* const kKeyGiantImageURL;
extern NSString* const kNImgPurchaseGiantLoaded;
extern NSString* const kNImgPurchaseGiantLoadError;


/**
 * Representation of the Purchase model mounted on the MemoryPool.
 */
@interface DWPurchase : DWPoolObject {
    NSString        *_title;
    NSString        *_endorsement;
    NSString        *_sourceURL;
    NSString        *_giantImageURL;
    NSString        *_fbObjectID;
    
    NSDate          *_createdAt;
    
    DWUser          *_user;
    DWStore         *_store;
    
    NSMutableArray  *_likes;
}

/**
 * Title of the purchase.
 */
@property (nonatomic,copy) NSString *title;

/**
 * Endorsement in favour of the purchase.
 */
@property (nonatomic,copy) NSString *endorsement;

/**
 * URL where more info can be found.
 */
@property (nonatomic,copy) NSString *sourceURL;

/**
 * URL of a giant sized purchase image.
 */
@property (nonatomic,copy) NSString *giantImageURL;

/**
 * ID of the object on facebook's open graph.
 */
@property (nonatomic,copy) NSString *fbObjectID;

/**
 * Date the purchase was created.
 */
@property (nonatomic,strong) NSDate *createdAt;


/**
 * The User who created the purchase.
 */
@property (nonatomic,strong) DWUser *user;

/**
 * The Store where the purchase was made
 */
@property (nonatomic,strong) DWStore *store;

/**
 * Likes made on the purchase.
 */
@property (nonatomic,strong) NSMutableArray *likes;


/**
 * Retrieve the giant purchase image.
 */
@property (nonatomic,readonly) UIImage* giantImage; 


/**
 * Start downloading the giant image
 */
- (void)downloadGiantImage;


/**
 * Prints out key fields for debugging.
 */
- (void)debug;

@end
