//
//  DWLoadingView.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWLoadingView.h"

static NSInteger const kSpinnerSize     = 20;

/**
 * Private method and property declarations
 */
@interface DWLoadingView()

/**
 * Create and add the spinner to the view
 */
- (void)createSpinner;

/**
 * Create and add the text label to the view
 */
- (void)createText;

/**
 * Create a textured background view using an image
 */
- (void)createBackground;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWLoadingView

//----------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        [self createBackground];
        [self createSpinner];
        [self createText];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------
- (void)createSpinner {
	
    UIActivityIndicatorView *spinner	= [[UIActivityIndicatorView alloc]
                                            initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    spinner.alpha   = 0.5;
	spinner.frame	= CGRectMake(109,(self.frame.size.height - kSpinnerSize) / 2 - 49,kSpinnerSize,kSpinnerSize);
    
    [spinner startAnimating];
	
	[self addSubview:spinner];	
}

//----------------------------------------------------------------------------------------------------
- (void)createText {
    
    UILabel *messageLabel			= [[UILabel alloc] 
                                        initWithFrame:CGRectMake(135,self.frame.size.height/ 2 - 10 - 49,90,20)];	
	messageLabel.backgroundColor	= [UIColor clearColor];
	messageLabel.font				= [UIFont fontWithName:@"HelveticaNeue" size:17];	
	messageLabel.textColor			= [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0];
	messageLabel.textAlignment		= UITextAlignmentLeft;
	messageLabel.text				= @"Loading...";
    
	[self addSubview:messageLabel];
}

//----------------------------------------------------------------------------------------------------
- (void)createBackground {	
}

@end
