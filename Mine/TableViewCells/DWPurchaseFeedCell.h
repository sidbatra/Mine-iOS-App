//
//  DWPurchaseFeedCell.h
//  Mine
//
//  Created by Siddharth Batra on 7/22/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OHAttributedLabel.h"


extern NSInteger const kTotalLikeUserImages;

@protocol DWPurchaseFeedCellDelegate;


@interface DWPurchaseFeedCell : UITableViewCell<OHAttributedLabelDelegate> {
    NSInteger           _purchaseID;
    NSInteger           _userID;
    
    UIButton            *purchaseImageButton;
    CALayer             *infoBackground;
    CALayer             *likesBackground;
    
    UIButton            *userImageButton;
    
    OHAttributedLabel   *boughtLabel;
    
    UIButton            *likeButton;
    UIButton            *allLikesButton;
    UIButton            *commentButton;
    
	UILabel             *endorsementLabel;
    OHAttributedLabel   *likesCountLabel;

    UIImageView         *likesChevron;
    
    __weak id<DWPurchaseFeedCellDelegate,NSObject> _delegate;
}


/**
 * ID of the puchase.
 */
@property (nonatomic,assign) NSInteger purchaseID;

/**
 * ID of the user who created the purchase.
 */
@property (nonatomic,assign) NSInteger userID;


/**
 * Delegate
 */
@property (nonatomic,weak) id<DWPurchaseFeedCellDelegate,NSObject> delegate;


/**
 * Reset UI for displaying likes
 */
- (void)resetLikesUI;

/**
 * Reset UI for displaying comments.
 */
- (void)resetCommentsUI;

/**
 * Apply a user image.
 */
- (void)setUserImage:(UIImage*)image;

/**
 * Apply a purchaese image
 */
- (void)setPurchaseImage:(UIImage*)image;

/**
 * Set the bought text for the purchase.
 */
- (void)setBoughtText:(NSString*)boughtText withUserName:(NSString*)userName;

/**
 * Set an endorsement.
 */
- (void)setEndorsement:(NSString*)endorsement;

/**
 * Disable like button interaction.
 */
- (void)disableLikeButton;

/**
 * Set like count for the purchase.
 */
- (void)setLikeCount:(NSInteger)count;

/**
 * Set like user image for the given index.
 */
- (void)setLikeImage:(UIImage*)image 
    forButtonAtIndex:(NSInteger)index
           forUserID:(NSInteger)userID;

/**
 * Add a comment onto the cell.
 */
- (void)createCommentWithUserImage:(UIImage*)image
                      withUserName:(NSString*)userName
                        withUserID:(NSInteger)userID
                        andMessage:(NSString*)message;

/**
 * Set comment user image button image;
 */
- (void)setCommentUserImage:(UIImage*)image
           forButtonAtIndex:(NSInteger)index;


/**
 * Compute the height of the cell based on the content.
 */
+ (NSInteger)heightForCellWithLikesCount:(NSInteger)likesCount 
                           commentsCount:(NSInteger)commentsCount
                          andEndorsement:(NSString*)endorsement;

@end


/**
 * Protocol for delgates of DWPurchaseFeedCell
 */
@protocol DWPurchaseFeedCellDelegate

@optional

/**
 * An element pointing to the purchase source url is clicked.
 */
- (void)purchaseURLClicked:(NSNumber*)purchaseID;

/**
 * A link to a user profile is clicked.
 */
- (void)userClicked:(NSNumber*)userID;

/**
 * User clicks like button.
 */
- (void)likeClickedForPurchaseID:(NSNumber*)purchaseID;

/**
 * Users clicks the via all likes button.
 */
- (void)allLikesClickedForPurchaseID:(NSNumber*)purchaseID;

/**
 * User clicks comment button.
 */
- (void)commentClickedForPurchaseID:(NSNumber*)purchaseID 
                 withCreationIntent:(NSNumber*)creationIntent;

@end