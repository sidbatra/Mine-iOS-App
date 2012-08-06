//
//  DWPurchaseProfileCell.h
//  Mine
//
//  Created by Siddharth Batra on 8/3/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DWPurchaseProfileCellDelegate;

@interface DWPurchaseProfileCell : UITableViewCell {
    __weak id<DWPurchaseProfileCellDelegate,NSObject> _delegate;
}

@property (nonatomic,weak) id<DWPurchaseProfileCellDelegate,NSObject> delegate;


/**
 * Reset UI
 */
- (void)resetUI;


/**
 * Apply a purchase image.
 */
- (void)setPurchaseImage:(UIImage*)image 
                forIndex:(NSInteger)index 
          withPurchaseID:(NSInteger)purchaseID;

/**
 * Apply a purchase title.
 */
- (void)setPurchaseTitle:(NSString*)title
                forIndex:(NSInteger)index 
          withPurchaseID:(NSInteger)purchaseID;


/**
 * Compute the height for the cell.
 */
+ (NSInteger)heightForCell;

@end


/**
 * Protocl for delegates of DWPurchaseProfileCell
 */
@protocol DWPurchaseProfileCellDelegate

@required

/**
 * An element pointing to a purhcase is clicked
 */
- (void)purchaseClicked:(NSInteger)purchaseID;

/**
 * An element pointing to the purchase source url is clicked.
 */
- (void)purchaseURLClicked:(NSInteger)purchaseID;

@end
