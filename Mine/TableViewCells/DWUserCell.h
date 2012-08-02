//
//  DWUserCell.h
//  Mine
//
//  Created by Siddharth Batra on 8/2/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DWUserCell : UITableViewCell


/**
 * Reset cell UI before changing the values.
 */
- (void)resetUI;

/**
 * Set the user image in the cell.
 */
- (void)setUserImage:(UIImage*)image;

/**
 * Set the user name in the cell.
 */
- (void)setUserName:(NSString*)userName;


/**
 * Return the height of the cell.
 */
+ (NSInteger)heightForCell;

@end
