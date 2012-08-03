//
//  DWPurchaseProfileCell.h
//  Mine
//
//  Created by Siddharth Batra on 8/3/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DWPurchaseProfileCell : UITableViewCell


/**
 * Reset UI
 */
- (void)resetUI;

/**
 * Apply a purchase title
 */
//- (void)setPurchaseTitle:(NSString*)title
//                forIndex:(NSInteger)index;

/**
 * Apply a purchase image.
 */
- (void)setPurchaseImage:(UIImage*)image 
                forIndex:(NSInteger)index 
          withPurchaseID:(NSInteger)purchaseID;


/**
 * Compute the height for the cell.
 */
+ (NSInteger)heightForCell;

@end
