//
//  DWUserCell.h
//  Mine
//
//  Created by Siddharth Batra on 8/2/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DWFollowButton.h"

@protocol DWUserCellDelegate;


@interface DWUserCell : UITableViewCell<DWFollowButtonDelegate> {
    NSInteger _userID;
    
    __weak id<DWUserCellDelegate,NSObject> _delegate;
}

@property (nonatomic,assign) NSInteger userID;
@property (nonatomic,weak) id<DWUserCellDelegate,NSObject> delegate;


/**
 * Reset cell UI before changing the values.
 */
- (void)resetUI;
- (void)displayActiveFollowing;
- (void)displayInactiveFollowing;

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


@protocol DWUserCellDelegate

@required

- (void)userCellFollowClickedForUserID:(NSInteger)userID;

@end