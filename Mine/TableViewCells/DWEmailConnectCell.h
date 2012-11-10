//
//  DWEmailConnectCell.h
//  Mine
//
//  Created by Deepak Rao on 11/6/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DWEmailConnectCellDelegate;


@interface DWEmailConnectCell : UITableViewCell {
    __weak id<DWEmailConnectCellDelegate,NSObject> _delegate;
}

@property (nonatomic,weak) id<DWEmailConnectCellDelegate,NSObject> delegate;


- (void)setTitle:(NSString*)title
     andSubtitle:(NSString*)subtitle;

+ (NSInteger)heightForCell;

@end



/**
 * Protocol for delgates of DWEmailConnectCell
 */
@protocol DWEmailConnectCellDelegate

@required

- (void)googleConnectClicked;
- (void)yahooConnectClicked;

@end