//
//  DWNavigationBarCountView.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWNavigationBarCountView.h"
#import <QuartzCore/QuartzCore.h>


static NSString* const kImgNonZeroOff       = @"nav-notifications-notzero-off.png";
static NSString* const kImgNonZeroOn        = @"nav-notifications-notzero-on.png";
static NSString* const kImgZeroOff          = @"nav-notifications-zero-off.png";
static NSString* const kImgZeroOn           = @"nav-notifications-zero-on.png";
static NSString* const kDefaultText         = @"0";

#define kColorTextDisabled  [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0]
#define kColorTextEnabled   [UIColor whiteColor]




@interface DWNavigationBarCountView()

/**
 * Add the background button to the view
 */
- (void)createBackgroundButton;

/**
 * Add the count label to the view
 */
- (void)createCountLabel;   

/**
 * Display active UI - usually decided as a function of the count
 */
- (void)displayActiveUI;

/**
 * Display inactive UI - usually decided as a function of the count
 */
- (void)displayInactiveUI;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWNavigationBarCountView

@synthesize delegate = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {       
        [self createBackgroundButton];
        [self createCountLabel];
        [self displayInactiveUI];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)createBackgroundButton {
    backgroundButton                = [UIButton buttonWithType:UIButtonTypeCustom];
    backgroundButton.frame          = CGRectMake(0,0,self.frame.size.width,self.frame.size.height);
    
    [backgroundButton addTarget:self 
                         action:@selector(didTapBackgroundButton:event:) 
               forControlEvents:UIControlEventTouchUpInside];
    
    
    [self addSubview:backgroundButton];
}

//----------------------------------------------------------------------------------------------------
- (void)createCountLabel {
    countLabel                        = [[UILabel alloc] initWithFrame:CGRectMake(1,0,self.frame.size.width+1,self.frame.size.height+1)];
    countLabel.backgroundColor        = [UIColor clearColor];
    countLabel.textColor              = kColorTextEnabled;
    countLabel.userInteractionEnabled = NO;
    countLabel.text                   = kDefaultText;  
    countLabel.textAlignment          = UITextAlignmentCenter;
    countLabel.layer.shadowColor      = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0].CGColor;
    countLabel.layer.shadowOffset     = CGSizeMake(0,1);
    countLabel.layer.shadowRadius     = 0;
    countLabel.layer.shadowOpacity    = 0.28;
    countLabel.font                   = [UIFont fontWithName:@"HelveticaNeue-Bold"
                                                        size:16];
    
    [self addSubview:countLabel];
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    self.delegate = nil;
    
}

//----------------------------------------------------------------------------------------------------
- (void)displayActiveUI {
    [backgroundButton setBackgroundImage:[UIImage imageNamed:kImgNonZeroOff]
                                forState:UIControlStateNormal];
    
    [backgroundButton setBackgroundImage:[UIImage imageNamed:kImgNonZeroOn]
                                forState:UIControlStateHighlighted];
}

//----------------------------------------------------------------------------------------------------
- (void)displayInactiveUI {
    [backgroundButton setBackgroundImage:[UIImage imageNamed:kImgZeroOff]
                                forState:UIControlStateNormal];
    
    [backgroundButton setBackgroundImage:[UIImage imageNamed:kImgZeroOn]
                                forState:UIControlStateHighlighted];
}

//----------------------------------------------------------------------------------------------------
- (void)setCount:(NSInteger)count {
    countLabel.text   = [NSString stringWithFormat:@"%d",count];
    
    if (count)
        [self displayActiveUI];
    else
        [self displayInactiveUI];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UI Events

//----------------------------------------------------------------------------------------------------
- (void)didTapBackgroundButton:(id)sender 
                         event:(id)event {
    
    [self.delegate navBarCountViewButtonClicked];
}

@end
