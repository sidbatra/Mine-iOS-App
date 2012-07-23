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
	UILabel  *messageLabel;
}

/**
 * Set a new message on to the message label
 */
- (void)setMessage:(NSString*)message;

@end
