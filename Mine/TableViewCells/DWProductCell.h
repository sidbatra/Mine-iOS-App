//
//  DWProductCell.h
//  Mine
//
//  Created by Deepak Rao on 7/31/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSInteger const kProductCellHeight;

@protocol DWProductCellDelegate;


@interface DWProductCell : UITableViewCell {
    __weak id<DWProductCellDelegate,NSObject> _delegate;    
}

/**
 * Delegate
 */
@property (nonatomic,weak) id<DWProductCellDelegate,NSObject> delegate;


/**
 * Reset UI
 */
- (void)resetUI;

/**
 * 
 */
- (void)setProductImage:(UIImage*)image 
       forButtonAtIndex:(NSInteger)index 
           andProductID:(NSInteger)productID;

@end


/**
 * Protocol for delgates of DWProductCell
 */
@protocol DWProductCellDelegate

@optional

/**
 * Fired when a product is clicked.
 */
- (void)productClicked:(NSNumber*)productID;

/** 
 * Fired when a product cell is touched
 */
- (void)productCellTouched;

@end