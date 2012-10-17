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
static NSString* const kImgCloseOff = @"nav-btn-close-off.png";
static NSString* const kImgCloseOn  = @"nav-btn-close-on.png";



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
+ (UIBarButtonItem*)navBarButtonWithTarget:(id)target
                                  selector:(SEL)selector
                                   onImage:(NSString*)onImage
                                  offImage:(NSString*)offImage {
    
    return [self navBarButtonWithTarget:target
                               selector:selector
                                onImage:onImage
                               offImage:offImage
                                  frame:CGRectMake(0,0,53,30)];
}

//----------------------------------------------------------------------------------------------------
+ (UIBarButtonItem*)navBarButtonWithTarget:(id)target
                                  selector:(SEL)selector
                                   onImage:(NSString*)onImage
                                  offImage:(NSString*)offImage
                                     frame:(CGRect)frame {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setBackgroundImage:[UIImage imageNamed:offImage]
                      forState:UIControlStateNormal];
    
    [button setBackgroundImage:[UIImage imageNamed:onImage]
                      forState:UIControlStateHighlighted];
    
	[button addTarget:target
               action:selector
     forControlEvents:UIControlEventTouchUpInside];
    
	[button setFrame:frame];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];    
}

//----------------------------------------------------------------------------------------------------
+ (UIBarButtonItem*)navBarDoneButtonWithTarget:(id)target {
    
    return [self navBarButtonWithTarget:target
                               selector:@selector(doneButtonClicked)
                                onImage:kImgDoneOn
                               offImage:kImgDoneOff];
}


//----------------------------------------------------------------------------------------------------
+ (UIBarButtonItem*)navBarSaveButtonWithTarget:(id)target {

    return [self navBarButtonWithTarget:target
                               selector:@selector(saveButtonClicked)
                                onImage:kImgSaveOn
                               offImage:kImgSaveOff];
}

//----------------------------------------------------------------------------------------------------
+ (UIBarButtonItem*)navBarNextButtonWithTarget:(id)target {
    
    return [self navBarButtonWithTarget:target
                               selector:@selector(nextButtonClicked)
                                onImage:kImgNextOn
                               offImage:kImgNextOff];
}

//----------------------------------------------------------------------------------------------------
+ (UIBarButtonItem*)navBarSendButtonWithTarget:(id)target {
    
    return [self navBarButtonWithTarget:target
                               selector:@selector(sendButtonClicked)
                                onImage:kImgSendOn
                               offImage:kImgSendOff];
}

//----------------------------------------------------------------------------------------------------
+ (UIBarButtonItem*)navBarCloseButtonWithTarget:(id)target {
    
    return [self navBarButtonWithTarget:target
                               selector:@selector(closeButtonClicked)
                                onImage:kImgCloseOn
                               offImage:kImgCloseOff
                                  frame:CGRectMake(0, 0, 58, 30)];
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
