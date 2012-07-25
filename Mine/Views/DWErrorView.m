//
//  DWErrorView.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWErrorView.h"


static NSInteger const kSpinnerSize     = 20;
static NSString* const kImgRefresh      = @"post_retry.png";
static NSString* const kMsgRefreshText  = @"Try again";


/**
 * Private method and property declarations
 */
@interface DWErrorView()

/**
 * Create and add the text label to the view
 */
- (void)createText;

/**
 * Create a textured background view using an image
 */
- (void)createBackground;

/**
 * Refresh icon
 */
- (void)createRefreshImage;

/**
 * Label to display refresh text
 */
- (void)createRefreshText;

/**
 * Create an invisible button to handle clicks anywhere
 * on the view
 */
- (void)createViewButton;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWErrorView

@synthesize delegate = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor =  [UIColor blackColor];
        
        //[self createBackground];
        [self createText];
        [self createRefreshImage];
        [self createRefreshText];
        [self createViewButton];
        
        [self hide];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)createText {
    
    messageLabel                   = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                                 self.frame.size.height / 2 - 35 - 49,
                                                                                 self.frame.size.width,
                                                                                 20)];	
	messageLabel.backgroundColor	= [UIColor clearColor];
	messageLabel.font				= [UIFont fontWithName:@"HelveticaNeue" size:17];	
	messageLabel.textColor			= [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
	messageLabel.textAlignment		= UITextAlignmentCenter;
    
	[self addSubview:messageLabel];
}

//----------------------------------------------------------------------------------------------------
- (void)createBackground {
	//[self addSubview:[DWGUIManager backgroundImageViewWithFrame:self.frame]];
}

//----------------------------------------------------------------------------------------------------
- (void)createRefreshImage {
    refreshImageView                    = [[UIImageView alloc] initWithFrame:CGRectMake(112,
                                                                                         self.frame.size.height / 2 - 9 - 49,
                                                                                         13,
                                                                                         15)];	
	refreshImageView.image              = [UIImage imageNamed:kImgRefresh];
	
	[self addSubview:refreshImageView];
}

//----------------------------------------------------------------------------------------------------
- (void)createRefreshText {
    refreshLabel                    = [[UILabel alloc] initWithFrame:CGRectMake(8,
                                                                                 self.frame.size.height / 2 - 10 - 49,
                                                                                 self.frame.size.width,
                                                                                 20)];	
	refreshLabel.backgroundColor	= [UIColor clearColor];
	refreshLabel.font				= [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];	
	refreshLabel.textColor			= [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
	refreshLabel.textAlignment		= UITextAlignmentCenter;
    refreshLabel.text               = kMsgRefreshText;
    
	[self addSubview:refreshLabel];
}

//----------------------------------------------------------------------------------------------------
- (void)createViewButton {
    viewButton          = [UIButton buttonWithType:UIButtonTypeCustom];
    viewButton.frame    = self.frame;
    
    [viewButton addTarget:self
                   action:@selector(didTapViewButton:)
         forControlEvents:UIControlEventTouchDown];
    
    [self addSubview:viewButton];
}



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWErrorViewProtocol

//----------------------------------------------------------------------------------------------------
- (void)setErrorMessage:(NSString *)message {
    messageLabel.text = message;
}

//----------------------------------------------------------------------------------------------------
- (void)hide {
    refreshLabel.hidden     = YES;
    refreshImageView.hidden = YES;
    viewButton.enabled      = NO;
    
    self.hidden = YES;
}

//----------------------------------------------------------------------------------------------------
- (void)showWithRefreshUI:(BOOL)showRefreshUI {
    
    if(showRefreshUI) {
        refreshLabel.hidden     = NO;
        refreshImageView.hidden = NO;
        viewButton.enabled      = YES;
    }
    
    self.hidden = NO;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UI Events

//----------------------------------------------------------------------------------------------------
- (void)didTapViewButton:(UIButton*)button {
    
    SEL sel = @selector(errorViewTouched);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    [self.delegate performSelector:sel];
}


@end
