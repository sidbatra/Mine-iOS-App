//
//  DWPurchaseFeedCell.h
//  Mine
//
//  Created by Siddharth Batra on 7/22/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


extern NSInteger const kPurchaseFeedCellHeight;
extern NSInteger const kTotalLikeUserButtons;

@protocol DWPurchaseFeedCellDelegate;


@interface DWPurchaseFeedCell : UITableViewCell {
    NSInteger       _purchaseID;
    NSInteger       _userID;
    
    UIImageView     *purchaseImageView;
    
    UIButton        *userImageButton;
    UIButton        *userNameButton;
    
	UILabel         *titleLabel;
    UILabel         *likesCountLabel;
    
    NSMutableArray  *_likeUserButtons;
    
    NSMutableArray  *_commentUserButtons;
    
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
 * User image buttons for the likers of this purchase.
 */
@property (nonatomic,strong) NSMutableArray *likeUserButtons;

/**
 * User image buttons for comments on this purchase.
 */
@property (nonatomic,strong) NSMutableArray *commentUserButtons;

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
 * Set user name for the purchase.
 */
- (void)setUserName:(NSString*)userName;

/**
 * Set purchase title.
 */
- (void)setTitle:(NSString*)title;

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
 * Compute the height of the cell based on the content.
 */
+ (NSInteger)heightForCellWithLikesCount:(NSInteger)likesCount 
                        andCommentsCount:(NSInteger)commentsCount;

@end


/**
 * Protocol for delgates of DWPurchaseFeedCell
 */
@protocol DWPurchaseFeedCellDelegate

@optional

/**
 * A link to a user profile is clicked.
 */
- (void)userClicked:(NSNumber*)userID;

@end