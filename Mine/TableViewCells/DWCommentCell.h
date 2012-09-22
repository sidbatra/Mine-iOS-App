//
//  DWCommentCell.h
//  Mine
//
//  Created by Siddharth Batra on 7/30/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OHAttributedLabel.h"


@protocol DWCommentCellDelegate;


@interface DWCommentCell : UITableViewCell<OHAttributedLabelDelegate> {
    NSInteger   _commentID;
    
    __weak id<DWCommentCellDelegate,NSObject> _delegate;
}

/**
 * ID of the comment being displayed.
 */
@property (nonatomic,assign) NSInteger commentID;

/**
 * Delegate following the DWCommentCellDelegate protocol.
 */
@property (nonatomic,weak) id<DWCommentCellDelegate,NSObject> delegate;

/**
 * Apply commentor's image.
 */
- (void)setUserImage:(UIImage*)image;

- (void)setMessage:(NSString*)message userName:(NSString*)userName;


/**
 * Compute height of cell with the given message.
 */
+ (NSInteger)heightForCellWithMessage:(NSString*)message userName:(NSString*)userName; 

@end



/**
 * Protocol for delgates of DWCommentCell
 */
@protocol DWCommentCellDelegate

@required

/**
 * A link to a user profile is clicked.
 */
- (void)userClickedForCommentID:(NSNumber*)commentID;

@end