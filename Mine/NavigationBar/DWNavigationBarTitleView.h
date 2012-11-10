//
//  DWNavigationBarTitleView.h
//  Mine
//
//  Created by Siddharth Batra on 8/30/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DWNavigationBarTitleView : UIView


- (id)initWithFrame:(CGRect)frame 
       andImageName:(NSString*)imageName;

- (id)initWithFrame:(CGRect)frame
              title:(NSString*)title
         andSpinner:(BOOL)isSpinner;

/**
 * Factory method for generating the mine logo title view.
 */
+ (DWNavigationBarTitleView*)logoTitleView;

@end
