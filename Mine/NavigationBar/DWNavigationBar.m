//
//  DWNavigationBar.m
//  Mine
//
//  Created by Siddharth Batra on 8/29/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWNavigationBar.h"


static NSString* const kImgNavBarBg = @"nav-bg.png";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWNavigationBar

//----------------------------------------------------------------------------------------------------
- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);	
	
	[[UIImage imageNamed:kImgNavBarBg] drawAtPoint:CGPointMake(0,0)];
	
	CGContextRestoreGState(context);
}


@end
