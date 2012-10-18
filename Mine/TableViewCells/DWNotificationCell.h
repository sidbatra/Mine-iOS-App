//
//  DWNotificationCell.h
//  Mine
//
//  Created by Siddharth Batra on 10/14/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DWNotificationCell : UITableViewCell {
}

- (void)resetUI;
- (void)setNotificationImage:(UIImage*)image;
- (void)setEvent:(NSString*)event entity:(NSString*)entity;
- (void)resetDarkMode;
- (void)setDarkMode;


+ (NSInteger)heightForCellWithEvent:(NSString*)event entity:(NSString*)entity;

@end
