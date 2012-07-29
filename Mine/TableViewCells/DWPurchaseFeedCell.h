//
//  DWPurchaseFeedCell.h
//  Mine
//
//  Created by Siddharth Batra on 7/22/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


extern NSInteger const kPurchaseFeedCellHeight;


@protocol DWPurchaseFeedCellDelegate;


@interface DWPurchaseFeedCell : UITableViewCell {
    NSInteger       _purchaseID;
    
    UIImageView     *purchaseImageView;
    
    UIButton        *userImageButton;
    UIButton        *userNameButton;
    
	UILabel         *titleLabel;
    UILabel         *likesCountLabel;
    
    __weak id<DWPurchaseFeedCellDelegate,NSObject> _delegate;
}


/**
 * ID of the puchase.
 */
@property (nonatomic,assign) NSInteger purchaseID;

/**
 * Delegate
 */
@property (nonatomic,weak) id<DWPurchaseFeedCellDelegate,NSObject> delegate;


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
 * Set likes for the purchase.
 */
- (void)setLikes:(NSArray*)likes;


/**
 * Compute the height of the cell based on the content.
 */
+ (NSInteger)heightForCellWithLikes:(NSArray*)likes;

@end


/**
 * Protocol for delgates of DWPurchaseFeedCell
 */
@protocol DWPurchaseFeedCellDelegate

@optional

/**
 * A link to a user profile is clicked.
 */
- (void)userClickedForPurchaseID:(NSNumber*)purchaseID;

@end