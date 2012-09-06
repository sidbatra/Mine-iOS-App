//
//  DWUserProfileCell.h
//  Mine
//
//  Created by Siddharth Batra on 9/4/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DWUserProfileCell : UITableViewCell


/**
 * Reset cell UI before changing the values.
 */
- (void)resetUI;

- (void)setUserImage:(UIImage*)image;
- (void)setUserName:(NSString*)userName;
- (void)setByline:(NSString*)byline   
  followingsCount:(NSInteger)followingsCount
   followersCount:(NSInteger)followersCount;

/**
 * Return the height of the cell.
 */
+ (NSInteger)heightForCellWithByline:(NSString*)byline
                    connectionsCount:(NSInteger)connectionsCount;

@end
