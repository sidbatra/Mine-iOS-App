//
//  DWGUIManager.m
//  Mine
//
//  Created by Deepak Rao on 9/10/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWGUIManager.h"


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

@end
