//
//  DWFollowButtonDelegate.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWFollowButton.h"
#import "DWConstants.h"

static NSString* const kImgInactiveButton                   = @"nav-btn-follow-off.png";
static NSString* const kImgInactiveButtonHighlighted        = @"nav-btn-follow-on.png";
static NSString* const kImgActiveButton                     = @"list-btn-follow-off.png";
static NSString* const kImgActiveButtonHighlighted          = @"list-btn-follow-off.png";


@interface DWFollowButton() {
    BOOL _isActive;
}

/**
 * Whether the following is active or not.
 */
@property (nonatomic,assign) BOOL isActive;

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

@synthesize isActive    = _isActive;
@synthesize delegate    = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
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
	spinner			= [[UIActivityIndicatorView alloc] 
                       initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	spinner.frame	= CGRectMake(self.frame.size.width/2-10,self.frame.size.height/2-10,20,20);
    spinner.hidden  = YES;    
	
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
    
    [underlayButton setBackgroundImage:[UIImage imageNamed:kImgActiveButton]
                              forState:UIControlStateNormal];
    
    [underlayButton setBackgroundImage:[UIImage imageNamed:kImgActiveButtonHighlighted]
                              forState:UIControlStateHighlighted];

}

//----------------------------------------------------------------------------------------------------
- (void)enterInactiveState {
    [self reset];
    
    self.isActive = NO;
    
    [underlayButton setBackgroundImage:[UIImage imageNamed:kImgInactiveButton]
                              forState:UIControlStateNormal];
    
    [underlayButton setBackgroundImage:[UIImage imageNamed:kImgInactiveButtonHighlighted]
                              forState:UIControlStateHighlighted];
}

//----------------------------------------------------------------------------------------------------
- (void)startSpinning {
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
