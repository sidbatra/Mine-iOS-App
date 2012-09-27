//
//  DWFollowButtonDelegate.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWFollowButton.h"
#import "DWConstants.h"

static NSString* const kImgDarkInactiveButton                   = @"nav-btn-follow-off.png";
static NSString* const kImgDarkInactiveButtonHighlighted        = @"nav-btn-follow-on.png";
static NSString* const kImgDarkInactiveSpinning                 = @"nav-btn-follow-loading.png";
static NSString* const kImgDarkActiveButton                     = @"nav-btn-following-off.png";
static NSString* const kImgDarkActiveButtonHighlighted          = @"nav-btn-following-on.png";
static NSString* const kImgDarkActiveSpinning                   = @"nav-btn-following-loading.png";

static NSString* const kImgLightInactiveButton                   = @"list-btn-follow-off.png";
static NSString* const kImgLightInactiveButtonHighlighted        = @"list-btn-follow-on.png";
static NSString* const kImgLightInactiveSpinning                 = @"list-btn-follow-loading.png";
static NSString* const kImgLightActiveButton                     = @"list-btn-following-off.png";
static NSString* const kImgLightActiveButtonHighlighted          = @"list-btn-following-on.png";
static NSString* const kImgLightActiveSpinning                   = @"list-btn-follow-loading.png";



@interface DWFollowButton() {
    BOOL _isActive;
    DWFollowButtonStyle _followButtonStyle;
}


@property (nonatomic,assign) BOOL isActive;
@property (nonatomic,assign) DWFollowButtonStyle followButtonStyle;


/**
 * Called prior to state transitions.
 */
- (void)reset;

/**
 * View creation methods
 */
- (void)createUnderlayButton;
- (void)createSpinner;
@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWFollowButton

@synthesize isActive            = _isActive;
@synthesize followButtonStyle   = _followButtonStyle;
@synthesize delegate            = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame followButtonStyle:(DWFollowButtonStyle)followButtonStyle {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.followButtonStyle = followButtonStyle;
        
        [self createUnderlayButton];
        [self createSpinner];
        
        [self enterInactiveState];
        [self startSpinning];
    }
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)createUnderlayButton {    
    underlayButton              = [UIButton buttonWithType:UIButtonTypeCustom];
    underlayButton.frame        = CGRectMake(0,0,self.frame.size.width,self.frame.size.height);
    
    [underlayButton addTarget:self 
                       action:@selector(didTouchDownOnButton:) 
             forControlEvents:UIControlEventTouchDown];
    
    [underlayButton addTarget:self
                       action:@selector(didTouchUpInsideButton:) 
             forControlEvents:UIControlEventTouchUpInside];
    
    [underlayButton addTarget:self
                       action:@selector(didOtherTouchesToButton:) 
             forControlEvents:UIControlEventTouchUpOutside];
    
    [underlayButton addTarget:self
                       action:@selector(didOtherTouchesToButton:) 
             forControlEvents:UIControlEventTouchDragOutside];
    
    /*[underlayButton addTarget:self
     action:@selector(didOtherTouchesToButton:)
     forControlEvents:UIControlEventTouchDragInside];*/
    
    [self addSubview:underlayButton];
}

//----------------------------------------------------------------------------------------------------
- (void)createSpinner {
    CGFloat spinnerSide = self.followButtonStyle == kFollowButonStyleDark ? 14.0 : 15.0;
    
	spinner			= [[UIActivityIndicatorView alloc] 
                       initWithActivityIndicatorStyle:self.followButtonStyle == kFollowButonStyleDark ? UIActivityIndicatorViewStyleWhite : UIActivityIndicatorViewStyleGray];
	spinner.frame	= CGRectMake((self.frame.size.width-spinnerSide)/2,(self.frame.size.height-spinnerSide)/2,spinnerSide,spinnerSide);
    spinner.hidden  = YES;
    spinner.transform = CGAffineTransformMakeScale(spinnerSide/20.0, spinnerSide/20.0);
	
	[self addSubview:spinner];
}

//----------------------------------------------------------------------------------------------------
- (void)reset {
    underlayButton.enabled = YES;
    spinner.hidden = YES;
    [spinner stopAnimating];
}

//----------------------------------------------------------------------------------------------------
- (void)enterActiveState {
    [self reset];
    
    self.isActive = YES;
    
    [underlayButton setBackgroundImage:[UIImage imageNamed:self.followButtonStyle == kFollowButonStyleDark ? kImgDarkActiveButton : kImgLightActiveButton]
                              forState:UIControlStateNormal];
    
    [underlayButton setBackgroundImage:[UIImage imageNamed:self.followButtonStyle == kFollowButonStyleDark ? kImgDarkActiveButtonHighlighted :  kImgLightActiveButtonHighlighted]
                              forState:UIControlStateHighlighted];

}

//----------------------------------------------------------------------------------------------------
- (void)enterInactiveState {
    [self reset];
    
    self.isActive = NO;
    
    [underlayButton setBackgroundImage:[UIImage imageNamed:self.followButtonStyle == kFollowButonStyleDark ? kImgDarkInactiveButton : kImgLightInactiveButton]
                              forState:UIControlStateNormal];
    
    [underlayButton setBackgroundImage:[UIImage imageNamed:self.followButtonStyle == kFollowButonStyleDark ? kImgDarkInactiveButtonHighlighted : kImgLightInactiveButtonHighlighted]
                              forState:UIControlStateHighlighted];
}

//----------------------------------------------------------------------------------------------------
- (void)startSpinning {
    
    if(self.isActive) {
        [underlayButton setBackgroundImage:[UIImage imageNamed:self.followButtonStyle == kFollowButonStyleDark ? kImgDarkActiveSpinning : kImgLightActiveSpinning]
                                  forState:UIControlStateNormal];
    }
    else {
        [underlayButton setBackgroundImage:[UIImage imageNamed:self.followButtonStyle == kFollowButonStyleDark ? kImgDarkInactiveSpinning : kImgLightInactiveSpinning]
                                  forState:UIControlStateNormal];
    }
    
    underlayButton.enabled = NO;
    spinner.hidden = NO;
    [spinner startAnimating];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Button Touch Events

//----------------------------------------------------------------------------------------------------
- (void)didTouchDownOnButton:(UIButton*)button {
}

//----------------------------------------------------------------------------------------------------
- (void)didTouchUpInsideButton:(UIButton*)button {
    [self startSpinning];
    [self.delegate followButtonClicked];
}

//----------------------------------------------------------------------------------------------------
- (void)didOtherTouchesToButton:(UIButton*)button {
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors
//----------------------------------------------------------------------------------------------------
- (void)shouldBeRemovedFromNav {
}

@end
