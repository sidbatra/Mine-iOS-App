//
//  DWCommentCell.h
//  Mine
//
//  Created by Siddharth Batra on 7/30/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DWCommentCell : UITableViewCell


/**
 * Apply commentor's image.
 */
- (void)setUserImage:(UIImage*)image;

/**
 * Apply commentor's name
 */
- (void)setUserName:(NSString*)userName;

/**
 * Apply the comment message.
 */
- (void)setMessage:(NSString*)message;


/**
 * Compute height of cell with the given message.
 */
+ (NSInteger)heightForCellWithMessage:(NSString*)message;

@end
