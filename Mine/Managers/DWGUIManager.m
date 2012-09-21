//
//  DWGUIManager.m
//  Mine
//
//  Created by Deepak Rao on 9/10/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWGUIManager.h"
#import "DWConstants.h"

static NSString* const kImgSaveOff  = @"nav-btn-save-off.png";
static NSString* const kImgSaveOn   = @"nav-btn-save-on.png";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWGUIManager

//----------------------------------------------------------------------------------------------------
+ (UILabel*)navBarTitleViewWithText:(NSString*)text {
    
    UILabel *titleLabel             = [[UILabel alloc] initWithFrame:CGRectMake(10,3,180,22)];
    titleLabel.textColor            = [UIColor whiteColor];
    titleLabel.textAlignment        = UITextAlignmentCenter;
    titleLabel.backgroundColor      = [UIColor clearColor];
    titleLabel.shadowColor          = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.48];
    titleLabel.shadowOffset         = CGSizeMake(0, 1);
    titleLabel.font                 = [UIFont fontWithName:@"HelveticaNeue-Bold" 
                                                     size:20];
    titleLabel.text                 = text;
    
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


//----------------------------------------------------------------------------------------------------
+ (UIBarButtonItem*)navBarSaveButtonWithTarget:(id)target {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];    
    
    [button setBackgroundImage:[UIImage imageNamed:kImgSaveOff] 
                      forState:UIControlStateNormal];
    
    [button setBackgroundImage:[UIImage imageNamed:kImgSaveOn] 
                      forState:UIControlStateHighlighted];
    
	[button addTarget:target
               action:@selector(saveButtonClicked)
     forControlEvents:UIControlEventTouchUpInside];
    
	[button setFrame:CGRectMake(0,0,58,30)];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
