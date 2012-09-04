//
//  DWNavigationBarBackButton.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWNavigationBarBackButton.h"


static NSString* const kImgBackButtonOn     = @"nav-btn-back-on.png";
static NSString* const kImgBackButtonOff    = @"nav-btn-back-off.png";



@interface DWNavigationBarBackButton()

/**
 * Creates the back button which occupies the entire view
 */
- (void)createButton;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWNavigationBarBackButton

@synthesize navigationController = _navigationController;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super initWithFrame:CGRectMake(0,0,56,30)];
    
    if (self) {
        [self createButton];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)createButton {
    UIButton *button    =  [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame        =  self.frame;
    
    [button setBackgroundImage:[UIImage imageNamed:kImgBackButtonOff] 
                      forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:kImgBackButtonOn] 
                      forState:UIControlStateHighlighted];
    
    [button addTarget:self 
               action:@selector(didTapButton:event:) 
     forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:button];
}

//----------------------------------------------------------------------------------------------------
+ (UIBarButtonItem*)backButtonForNavigationController:(UINavigationController*)navigationController {
    DWNavigationBarBackButton *backButton = [[DWNavigationBarBackButton alloc] init];
    backButton.navigationController = navigationController;
    
    return [[UIBarButtonItem alloc] initWithCustomView:backButton];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UIControlEvents

//----------------------------------------------------------------------------------------------------
- (void)didTapButton:(id)sender 
               event:(id)event {
	[self.navigationController popViewControllerAnimated:YES];
}



@end
