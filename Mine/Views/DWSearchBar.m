//
//  DWSearchBar.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWSearchBar.h"
#import "DWConstants.h"

static NSString* const kImgSearchBackground     = @"nav-field-search.png";
static NSString* const kImgCancelButton         = @"button_cancel.png";
static NSString* const kMsgSearchPlaceholder    = @"Search for people";

/**
 * Private method and property declarations
 */
@interface DWSearchBar()

/**
 * White background image behind the text field
 */
- (void)createBackground;

/**
 * Text field for writing search queries
 */
- (void)createSearchField;

/**
 * Cancel button for wiping the search view
 */
- (void)createCancelButton;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWSearchBar

@synthesize minimumQueryLength  = _minimumQueryLength;
@synthesize delegate            = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self createBackground];
        [self createSearchField];
        [self createCancelButton];        
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)createBackground {
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(7,6,250,32)];
    background.contentMode = UIViewContentModeCenter;
    background.image = [UIImage imageNamed:kImgSearchBackground];
    background.userInteractionEnabled    = NO;
    
    [self addSubview:background];
}

//----------------------------------------------------------------------------------------------------
- (void)createSearchField {
    searchTextField                         = [[UITextField alloc] initWithFrame:CGRectMake(38,13,220,20)];
    searchTextField.delegate                = self;
    searchTextField.autocorrectionType      = UITextAutocorrectionTypeNo;
    searchTextField.autocapitalizationType  = UITextAutocapitalizationTypeNone;
    searchTextField.font                    = [UIFont fontWithName:@"HelveticaNeue" size:14];	
	searchTextField.textColor               = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
	searchTextField.textAlignment           = UITextAlignmentLeft;
    searchTextField.clearButtonMode         = UITextFieldViewModeWhileEditing;
    searchTextField.placeholder             = kMsgSearchPlaceholder;
    searchTextField.returnKeyType           = UIReturnKeySearch;    
    
    
    [self addSubview:searchTextField];
}

//----------------------------------------------------------------------------------------------------
- (void)createCancelButton {
    UIButton *button    = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame        = CGRectMake(260,0,60,44);
    
    [button setBackgroundImage:[UIImage imageNamed:kImgCancelButton]
                                          forState:UIControlStateNormal];
    
    [button addTarget:self
               action:@selector(didTapCancelButton:)
     forControlEvents:UIControlEventTouchDown];
    
    
    [self addSubview:button];
}

//----------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------
- (void)becomeActive {
    [searchTextField becomeFirstResponder];
}

//----------------------------------------------------------------------------------------------------
- (void)resignActive {
    searchTextField.text = @"";
    [searchTextField resignFirstResponder];
}

//----------------------------------------------------------------------------------------------------
- (void)hideKeyboard {
    if ([searchTextField isFirstResponder])
        [searchTextField resignFirstResponder];    
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UISearchBarDelegate

//----------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if([searchTextField.text length] < _minimumQueryLength)
        return NO;
    
    [searchTextField resignFirstResponder];
    
    [self.delegate searchWithQuery:searchTextField.text];
    
    return YES;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UI Events

//----------------------------------------------------------------------------------------------------
- (void)didTapCancelButton:(UIButton*)button {
    [self.delegate searchCancelled];
}


@end
