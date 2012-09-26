//
//  DWPaginationCell.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSInteger const kPaginationCellHeight;

/**
 * Cell indicates auto-pagination is in progress
 */
@interface DWPaginationCell : UITableViewCell {
}

- (void)displaySpinner;

@end