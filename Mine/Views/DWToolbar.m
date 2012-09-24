//
//  DWToolbar.m
//  Mine
//
//  Created by Siddharth Batra on 9/24/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWToolbar.h"



static NSString* const kImgToolbarBg = @"tab-bar-bg.png";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWToolbar

//----------------------------------------------------------------------------------------------------
- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);	
	
	[[UIImage imageNamed:kImgToolbarBg] drawAtPoint:CGPointMake(0,0)];
	
	CGContextRestoreGState(context);
}


@end
