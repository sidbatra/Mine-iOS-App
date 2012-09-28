//
//  DWLoadingView.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWLoadingView.h"

#import "DWDevice.h"

static NSInteger const kSpinnerSize     = 20;

/**
 * Private method and property declarations
 */
@interface DWLoadingView()

- (void)createSpinner;
- (void)createText;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWLoadingView

//----------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1.0];
        
        [self createSpinner];
        [self createText];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)createSpinner {

    UIActivityIndicatorView *spinner	= [[UIActivityIndicatorView alloc]
                                            initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	spinner.frame	= CGRectMake(113,([DWDevice sharedDWDevice].screenHeightMinusStatusBar - kSpinnerSize) / 2 - [DWDevice sharedDWDevice].navBarHeight - 6,kSpinnerSize,kSpinnerSize);
    
    [spinner startAnimating];
	
	[self addSubview:spinner];	
}

//----------------------------------------------------------------------------------------------------
- (void)createText {
    
    UILabel *messageLabel			= [[UILabel alloc] 
                                        initWithFrame:CGRectMake(138.5,[DWDevice sharedDWDevice].screenHeightMinusStatusBar / 2 - [DWDevice sharedDWDevice].navBarHeight - 10 - 6,90,20)];
	messageLabel.backgroundColor	= [UIColor clearColor];
	messageLabel.font				= [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];	
	messageLabel.textColor			= [UIColor colorWithRed:0.454 green:0.454 blue:0.454 alpha:1.0];
	messageLabel.textAlignment		= UITextAlignmentLeft;
	messageLabel.text				= @"Loading...";
    
	[self addSubview:messageLabel];
}

@end
