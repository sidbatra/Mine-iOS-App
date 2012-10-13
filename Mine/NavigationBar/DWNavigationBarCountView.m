//
//  DWNavigationBarCountView.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWNavigationBarCountView.h"

//static NSString* const kImgBackground       = @"button_notifications";
static NSString* const kDefaultText         = @"0";
static CGFloat   const kDisabledOpacity     = 0.5;

#define kColorTextDisabled  [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0]
#define kColorBgDisabled    [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5]
#define kColorTextEnabled   [UIColor whiteColor]
#define kColorBgEnabled     [UIColor colorWithRed:0.8 green:0.2 blue:0.2 alpha:1.0]




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
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)createBackgroundButton {
    backgroundButton                = [UIButton buttonWithType:UIButtonTypeCustom];
    backgroundButton.alpha          = kDisabledOpacity;
    backgroundButton.frame          = CGRectMake(0,0,self.frame.size.width,self.frame.size.height);
    
    //[backgroundButton setBackgroundImage:[UIImage imageNamed:kImgBackground]
    //                            forState:UIControlStateNormal];
    
    [backgroundButton addTarget:self 
                         action:@selector(didTapBackgroundButton:event:) 
               forControlEvents:UIControlEventTouchUpInside];
    
    
    [self addSubview:backgroundButton];
}

//----------------------------------------------------------------------------------------------------
- (void)createCountLabel {
    countLabel                        = [[UILabel alloc] initWithFrame:CGRectMake(12,11,25,22)];
    countLabel.userInteractionEnabled = NO;
    countLabel.layer.cornerRadius     = 2.5;
    countLabel.text                   = kDefaultText;  
    countLabel.textAlignment          = UITextAlignmentCenter;
    countLabel.font                   = [UIFont fontWithName:@"HelveticaNeue-Bold" 
                                                        size:13];
    
    [self addSubview:countLabel];
    [self displayInactiveUI];
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    self.delegate = nil;
    
}

//----------------------------------------------------------------------------------------------------
- (void)displayActiveUI {
    countLabel.textColor        = kColorTextEnabled;        
    countLabel.backgroundColor  = kColorBgEnabled;
}

//----------------------------------------------------------------------------------------------------
- (void)displayInactiveUI {
    countLabel.textColor        = kColorTextDisabled;        
    countLabel.backgroundColor  = kColorBgDisabled;
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
    
    [self.delegate countButtonClicked];
}

@end
