//
//  DWGUIManager.m
//  Mine
//
//  Created by Deepak Rao on 9/10/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWGUIManager.h"
#import "DWConstants.h"


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWGUIManager

//----------------------------------------------------------------------------------------------------
+ (UILabel*)navBarTitleViewWithText:(NSString*)text {
    
    UILabel *titleLabel            = [[UILabel alloc] initWithFrame:CGRectMake(10,4,180,18)];
    titleLabel.textColor           = [UIColor whiteColor];
    titleLabel.textAlignment       = UITextAlignmentCenter;
    titleLabel.backgroundColor     = [UIColor clearColor];
    titleLabel.font                = [UIFont fontWithName:@"HelveticaNeue-Bold" 
                                                     size:17];
    titleLabel.text                = text;
    
    return titleLabel;
}

//----------------------------------------------------------------------------------------------------
+ (UIBarButtonItem*)navBarDoneButtonWithTarget:(id)target {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];    
    
    [button setBackgroundImage:[UIImage imageNamed:kImgDoneOff] 
                      forState:UIControlStateNormal];
    
    [button setBackgroundImage:[UIImage imageNamed:kImgDoneOn] 
                      forState:UIControlStateHighlighted];
    
	[button addTarget:target
               action:@selector(doneButtonClicked)
     forControlEvents:UIControlEventTouchUpInside];
    
	[button setFrame:CGRectMake(0,0,58,30)];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
