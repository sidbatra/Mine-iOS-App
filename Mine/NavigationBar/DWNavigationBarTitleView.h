//
//  DWNavigationBarTitleView.h
//  Mine
//
//  Created by Siddharth Batra on 8/30/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DWNavigationBarTitleView : UIView


/**
 * Init with frame in image only mode.
 */
- (id)initWithFrame:(CGRect)frame 
       andImageName:(NSString*)imageName;

/**
 * Factory method for generating the mine logo title view.
 */
+ (DWNavigationBarTitleView*)logoTitleView;

@end
