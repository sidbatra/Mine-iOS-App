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
    BOOL _userMode;
    
    __weak id<DWPurchaseProfileCellDelegate,NSObject> _delegate;
}

@property (nonatomic,assign) BOOL userMode;
@property (nonatomic,weak) id<DWPurchaseProfileCellDelegate,NSObject> delegate;


- (id)initWithStyle:(UITableViewCellStyle)style
	reuseIdentifier:(NSString *)reuseIdentifier
           userMode:(BOOL)userMode;

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

- (void)setUserImage:(UIImage*)image
            forIndex:(NSInteger)index
          withUserID:(NSInteger)userID;

/**
 * Apply a purchase title.
 */
- (void)setPurchaseTitle:(NSString*)title
                   store:(NSString*)store
                forIndex:(NSInteger)index
         withUserPronoun:(NSString*)pronoun
          withPurchaseID:(NSInteger)purchaseID;

- (void)enterSpinningStateForIndex:(NSInteger)index;

- (void)displayCrossButtonForIndex:(NSInteger)index;


/**
 * Compute the height for the cell.
 */
+ (NSInteger)heightForCellWithPurchases:(NSMutableArray*)purchases
                             inUserMode:(BOOL)userMode ;

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
