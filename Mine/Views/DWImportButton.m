//
//  DWImportButton.m
//  Mine
//
//  Created by Siddharth Batra on 11/5/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWImportButton.h"

static NSString* const kImgInactiveButton   = @"nav-btn-import-disabled.png";
static NSString* const kImgLoadingButton    = @"nav-btn-import-loading.png";
static NSString* const kImgActiveButtonOff  = @"nav-btn-import-off.png";
static NSString* const kImgActiveButtonOn   = @"nav-btn-import-on.png";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWImportButton

@synthesize delegate            = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self createUnderlayButton];
        [self createSpinner];
        
        [self enterInactiveState];
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
    CGFloat spinnerSide = 14.0;
    
	spinner			= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
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
        
    [underlayButton setBackgroundImage:[UIImage imageNamed:kImgActiveButtonOff]
                              forState:UIControlStateNormal];
    
    [underlayButton setBackgroundImage:[UIImage imageNamed:kImgActiveButtonOn]
                              forState:UIControlStateHighlighted];
    
}

//----------------------------------------------------------------------------------------------------
- (void)enterInactiveState {
    [self reset];
        
    [underlayButton setBackgroundImage:[UIImage imageNamed:kImgInactiveButton]
                              forState:UIControlStateNormal];
    
    [underlayButton setBackgroundImage:[UIImage imageNamed:kImgInactiveButton]
                              forState:UIControlStateDisabled];
    
    underlayButton.enabled = NO;
}

//----------------------------------------------------------------------------------------------------
- (void)enterLoadingState {
    [self reset];
    
    [underlayButton setBackgroundImage:[UIImage imageNamed:kImgLoadingButton]
                              forState:UIControlStateNormal];
    
    [underlayButton setBackgroundImage:[UIImage imageNamed:kImgLoadingButton]
                              forState:UIControlStateDisabled];
    
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
    [self enterLoadingState];
    [self.delegate importButtonClicked];
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
