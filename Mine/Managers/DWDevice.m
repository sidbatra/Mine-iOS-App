//
//  DWDevice.m
//  Mine
//
//  Created by Siddharth Batra on 9/27/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWDevice.h"

#import "SynthesizeSingleton.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWDevice

SYNTHESIZE_SINGLETON_FOR_CLASS(DWDevice);

//----------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	
	if(self) {
	}
	
	return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
}

//----------------------------------------------------------------------------------------------------
- (CGFloat)statusBarHeight {
    return 20.0;
}

//----------------------------------------------------------------------------------------------------
- (CGFloat)navBarHeight {
    return 44.0;
}

//----------------------------------------------------------------------------------------------------
- (CGFloat)screenWidth {
    return [[UIScreen mainScreen] bounds].size.width;
}

//----------------------------------------------------------------------------------------------------
- (CGFloat)screenHeight {
    return [[UIScreen mainScreen] bounds].size.height;
}

//----------------------------------------------------------------------------------------------------
- (CGFloat)screenHeightMinusStatusBar {
    return self.screenHeight - self.statusBarHeight;
}

//----------------------------------------------------------------------------------------------------
- (CGFloat)screenHeightMinusNav {
    return self.screenHeightMinusStatusBar - self.navBarHeight;
}


@end
