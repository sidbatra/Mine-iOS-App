//
//  DWErrorView.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWErrorView.h"
#import "DWDevice.h"


static NSInteger const kSpinnerSize     = 20;
static NSString* const kImgRefresh      = @"refresh-gray.png";
static NSString* const kMsgRefreshText  = @"Try again";


/**
 * Private method and property declarations
 */
@interface DWErrorView()


- (void)createText;
- (void)createRefreshImage;
- (void)createRefreshText;
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
        self.backgroundColor =  [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1.0];
        
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
                                                                               [DWDevice sharedDWDevice].screenHeightMinusStatusBar / 2 - [DWDevice sharedDWDevice].navBarHeight -10 - 14 - 19,
                                                                               self.frame.size.width,
                                                                               20)];	
	messageLabel.backgroundColor	= [UIColor clearColor];
	messageLabel.font				= [UIFont fontWithName:@"HelveticaNeue" size:17];	
	messageLabel.textColor			= [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0];
	messageLabel.textAlignment		= UITextAlignmentCenter;
    
	[self addSubview:messageLabel];
}

//----------------------------------------------------------------------------------------------------
- (void)createRefreshImage {
    refreshImageView                    = [[UIImageView alloc] initWithFrame:CGRectMake(116.5,
                                                                                        [DWDevice sharedDWDevice].screenHeightMinusStatusBar / 2 - [DWDevice sharedDWDevice].navBarHeight - 14,
                                                                                        13,
                                                                                        15)];
	refreshImageView.image              = [UIImage imageNamed:kImgRefresh];
	
	[self addSubview:refreshImageView];
}

//----------------------------------------------------------------------------------------------------
- (void)createRefreshText {
    refreshLabel                    = [[UILabel alloc] initWithFrame:CGRectMake(138.5,
                                                                                 [DWDevice sharedDWDevice].screenHeightMinusStatusBar / 2 - [DWDevice sharedDWDevice].navBarHeight - 14 - 2,
                                                                                 90,
                                                                                 20)];	
	refreshLabel.backgroundColor	= [UIColor clearColor];
	refreshLabel.font				= [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];	
	refreshLabel.textColor			= [UIColor colorWithRed:0.454 green:0.454 blue:0.454 alpha:1.0];
	refreshLabel.textAlignment		= UITextAlignmentLeft;
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
