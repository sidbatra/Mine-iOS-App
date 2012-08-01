//
//  DWProductCell.h
//  Mine
//
//  Created by Deepak Rao on 7/31/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSInteger const kProductCellHeight;


@interface DWProductCell : UITableViewCell {
    
}

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