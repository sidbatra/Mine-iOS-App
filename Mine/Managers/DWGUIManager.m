//
//  DWGUIManager.m
//  Mine
//
//  Created by Deepak Rao on 9/10/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWGUIManager.h"
#import "DWConstants.h"

static NSString* const kMsgErrorTitle       = @"Error";
static NSString* const kMsgCancelTitle      = @"Dismiss";
static NSString* const kMsgError            = @"Mine can't complete your request. Please try again later.";

static NSString* const kImgSaveOff  = @"nav-btn-save-off.png";
static NSString* const kImgSaveOn   = @"nav-btn-save-on.png";
static NSString* const kImgNextOff  = @"nav-btn-next-off.png";
static NSString* const kImgNextOn   = @"nav-btn-next-on.png";
static NSString* const kImgSendOff  = @"nav-btn-send-off.png";
static NSString* const kImgSendOn   = @"nav-btn-send-on.png";



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
    
	[button setFrame:CGRectMake(0,0,53,30)];
    
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
    
	[button setFrame:CGRectMake(0,0,53,30)];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

//----------------------------------------------------------------------------------------------------
+ (UIBarButtonItem*)navBarNextButtonWithTarget:(id)target {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setBackgroundImage:[UIImage imageNamed:kImgNextOff]
                      forState:UIControlStateNormal];
    
    [button setBackgroundImage:[UIImage imageNamed:kImgNextOn]
                      forState:UIControlStateHighlighted];
    
	[button addTarget:target
               action:@selector(nextButtonClicked)
     forControlEvents:UIControlEventTouchUpInside];
    
	[button setFrame:CGRectMake(0,0,53,30)];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

//----------------------------------------------------------------------------------------------------
+ (UIBarButtonItem*)navBarSendButtonWithTarget:(id)target {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setBackgroundImage:[UIImage imageNamed:kImgSendOff]
                      forState:UIControlStateNormal];
    
    [button setBackgroundImage:[UIImage imageNamed:kImgSendOn]
                      forState:UIControlStateHighlighted];
    
	[button addTarget:target
               action:@selector(sendButtonClicked)
     forControlEvents:UIControlEventTouchUpInside];
    
	[button setFrame:CGRectMake(0,0,53,30)];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

//----------------------------------------------------------------------------------------------------
+ (void)connectionErrorAlertView {
    [self connectionErrorAlertViewWithDelegate:nil];
}

//----------------------------------------------------------------------------------------------------
+ (void)connectionErrorAlertViewWithDelegate:(id)delegate {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kMsgErrorTitle
                                                    message:kMsgError
                                                   delegate:delegate
                                          cancelButtonTitle:kMsgCancelTitle
                                          otherButtonTitles:nil];
    [alert show];
}

@end
