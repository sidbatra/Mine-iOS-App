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
    
	UILabel         *messageLabel;
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
 * Set a new message on to the message label
 */
- (void)setMessage:(NSString*)message;

@end
