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

- (void)setNotificationImage:(UIImage*)image;
- (void)setEvent:(NSString*)event entity:(NSString*)entity;


+ (NSInteger)heightForCellWithEvent:(NSString*)event entity:(NSString*)entity;

@end
