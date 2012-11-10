//
//  DWUnapprovedPurchasesLoadingView.m
//  Mine
//
//  Created by Siddharth Batra on 11/6/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWUnapprovedPurchasesLoadingView.h"
#import "DWDevice.h"

static NSString* const kImgAnimationFormat = @"cat-wait-%d.jpg";
static NSInteger const kAnimationFrames = 19;
static NSInteger const kSpinnerSize = 20;


@interface DWUnapprovedPurchasesLoadingView()

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUnapprovedPurchasesLoadingView

//----------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1.0];
        
        [self createImageView];
        [self createText];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)createImageView {

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(40,
                                                                           ([DWDevice sharedDWDevice].screenHeightMinusStatusBar - 135) / 2 - [DWDevice sharedDWDevice].navBarHeight - 21,
                                                                           240,
                                                                           135)];
    

    NSMutableArray *frames = [NSMutableArray arrayWithCapacity:kAnimationFrames];
    
    for(NSInteger i=0; i<kAnimationFrames ; i++)
        [frames addObject:[UIImage imageNamed:[NSString stringWithFormat:kImgAnimationFormat,i+1]]];
    
    imageView.animationImages = frames;
    imageView.animationDuration = 0;
    
    [imageView startAnimating];
    
	[self addSubview:imageView];
}

//----------------------------------------------------------------------------------------------------
- (void)createText {
    
    UILabel *messageLabel			= [[UILabel alloc]
                                       initWithFrame:CGRectMake(0,[DWDevice sharedDWDevice].screenHeightMinusStatusBar / 2 - [DWDevice sharedDWDevice].navBarHeight - 10 + 68,self.frame.size.width,20)];
	messageLabel.backgroundColor	= [UIColor clearColor];
	messageLabel.font				= [UIFont fontWithName:@"HelveticaNeue" size:17];
	messageLabel.textColor			= [UIColor colorWithRed:0.454 green:0.454 blue:0.454 alpha:1.0];
	messageLabel.textAlignment		= UITextAlignmentCenter;
	messageLabel.text				= @"We'll only be a moment...";
    
	[self addSubview:messageLabel];
}

@end