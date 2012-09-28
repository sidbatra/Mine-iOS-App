//
//  DWDevice.h
//  Mine
//
//  Created by Siddharth Batra on 9/27/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DWDevice : NSObject

+ (DWDevice*)sharedDWDevice;


@property (nonatomic,readonly) CGFloat screenWidth;
@property (nonatomic,readonly) CGFloat screenHeight;
@property (nonatomic,readonly) CGFloat statusBarHeight;
@property (nonatomic,readonly) CGFloat navBarHeight;
@property (nonatomic,readonly) CGFloat screenHeightMinusStatusBar;
@property (nonatomic,readonly) CGFloat screenHeightMinusNav;

@end
