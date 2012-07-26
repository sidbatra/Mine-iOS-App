//
//  DWPurchaseFeedCell.h
//  Mine
//
//  Created by Siddharth Batra on 7/22/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


extern NSInteger const kPurchaseFeedCellHeight;



@interface DWPurchaseFeedCell : UITableViewCell {
    UIImageView     *userImageView;
    UIImageView     *purchaseImageView;
    
    UILabel         *userNameLabel;
	UILabel         *titleLabel;
}

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

@end
