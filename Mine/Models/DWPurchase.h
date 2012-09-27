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
@class DWLike;
@class DWComment;


/**
 * 
 */
extern NSString* const kKeyTitle;
extern NSString* const kKeyEndorsement;
extern NSString* const kKeySourceURL;
extern NSString* const kKeyFbObjectID;
extern NSString* const kKeyCreatedAt;
extern NSString* const kKeyStore;
extern NSString* const kKeyLikes;
extern NSString* const kKeyComments;
extern NSString* const kKeyOrigThumbURL;
extern NSString* const kKeyOrigImageURL;
extern NSString* const kKeyQuery;
extern NSString* const kKeySuggestionID;
extern NSString* const kKeyStoreName;
extern NSString* const kKeyIsStoreUnknown;
extern NSString* const kKeyShareToFB;
extern NSString* const kKeyShareToTW;
extern NSString* const kKeyShareToTB;
extern NSString* const kKeyProduct;

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
    NSString        *_origThumbURL;
    NSString        *_origImageURL;
    NSString        *_query;
    
    NSDate          *_createdAt;
    NSInteger       _suggestionID;
    
    DWUser          *_user;
    DWStore         *_store;
    
    NSMutableArray  *_likes;
    NSMutableArray  *_comments;
    
    BOOL            _isDestroying;
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
 * URL of the original thumbnail
 */
@property (nonatomic,copy) NSString *origThumbURL;

/**
 * URL of the original image
 */
@property (nonatomic,copy) NSString *origImageURL;

/**
 * The query used to create the purchase.
 */
@property (nonatomic,copy) NSString *query;

/**
 * Date the purchase was created.
 */
@property (nonatomic,strong) NSDate *createdAt;

/**
 * The suggestion id used to create the purchase.
 */
@property (nonatomic,assign) NSInteger suggestionID;


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
 * Comments made on the purchase.
 */
@property (nonatomic,strong) NSMutableArray *comments;

@property (nonatomic,assign) BOOL isDestroying;



/**
 * Retrieve the giant purchase image.
 */
@property (nonatomic,readonly) UIImage* giantImage; 


/**
 * Start downloading the giant image
 */
- (void)downloadGiantImage;


/**
 * Create a new unmounted comment on the purchase by the given user
 * with the given message;
 */
- (void)addTempCommentByUser:(DWUser*)user 
                 withMessage:(NSString*)message;

/**
 * Remove unmounted message with the given message.
 */
- (BOOL)removeTempCommentWithMessage:(NSString*)message;

/**
 * Replace unmounted comment with the mounted one.
 */
- (void)replaceTempCommentWithMountedComment:(DWComment*)newComment;


/**
 * Test if the purchase has been liked by the given user id.
 */
- (BOOL)isLikedByUserID:(NSInteger)userID;

/**
 * Create a new unmounted like on the purchase by the given user.
 */
- (void)addTempLikeByUser:(DWUser*)user;

/**
 * Remove the temp like added by addTempLikeByUser
 */
- (BOOL)removeTempLike;

/**
 * Replace temp like with a proper mounted one.
 */
- (void)replaceTempLikeWithMountedLike:(DWLike*)newLike;

/**
 * Prints out key fields for debugging.
 */
- (void)debug;

@end
