//
//  DWCommentCell.h
//  Mine
//
//  Created by Siddharth Batra on 7/30/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DWCommentCellDelegate;


@interface DWCommentCell : UITableViewCell {
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