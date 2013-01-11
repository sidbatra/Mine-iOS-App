//
//  DWEmailConnectCell.m
//  Mine
//
//  Created by Deepak Rao on 11/6/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWEmailConnectCell.h"
#import "DWAnalyticsManager.h"
#import "DWConstants.h"

static NSInteger const kEmailConnectCellHeight = 51;

static NSString* const kImgGoogleOff        = @"feed-btn-gmail-off.png";
static NSString* const kImgGoogleOn         = @"feed-btn-gmail-on.png";
static NSString* const kImgGoogleDisabled   = @"feed-btn-gmail-checked.png";
static NSString* const kImgYahooOff         = @"feed-btn-yahoo-off.png";
static NSString* const kImgYahooOn          = @"feed-btn-yahoo-on.png";
static NSString* const kImgYahooDisabled    = @"feed-btn-yahoo-checked.png";
static NSString* const kImgHotmailOff       = @"feed-btn-hotmail-off.png";
static NSString* const kImgHotmailOn        = @"feed-btn-hotmail-on.png";
static NSString* const kImgHotmailDisabled  = @"feed-btn-hotmail-checked.png";


@interface DWEmailConnectCell() {
    UILabel     *titleLabel;
    UILabel     *subtitleLabel;
    UIButton    *googleButton;
    UIButton    *yahooButton;
    UIButton    *hotmailButton;
}
@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWEmailConnectCell

@synthesize delegate = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)initWithStyle:(UITableViewCellStyle)style
	reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style
				reuseIdentifier:reuseIdentifier];
	
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithRed:0.2235 green:0.2235 blue:0.2235 alpha:1.0];
        
        [self createBorders];
        [self createTitleLabel];
        [self createSubtitleLabel];
        [self createConnectButtons];
        
		self.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)createBorders {
    
    UILabel *bottomBorder = [[UILabel alloc] initWithFrame:CGRectMake(0, kEmailConnectCellHeight-1, self.contentView.frame.size.width,1)];
    bottomBorder.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    
    [self.contentView addSubview:bottomBorder];
}

//----------------------------------------------------------------------------------------------------
- (void)createTitleLabel {
    titleLabel  = [[UILabel alloc] initWithFrame:CGRectMake(11,2,180,30)];
    
    titleLabel.backgroundColor      = [UIColor clearColor];
    titleLabel.font                 = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
    titleLabel.textColor            = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    titleLabel.textAlignment        = UITextAlignmentLeft;
    
    [self.contentView addSubview:titleLabel];
}

//----------------------------------------------------------------------------------------------------
- (void)createSubtitleLabel {
    subtitleLabel  = [[UILabel alloc] initWithFrame:CGRectMake(11,22,158,24)];
    
    subtitleLabel.backgroundColor       = [UIColor clearColor];
    subtitleLabel.font                  = [UIFont fontWithName:@"HelveticaNeue" size:11];
    subtitleLabel.textColor             = [UIColor colorWithRed:0.6 green:0.6 blue:0.6  alpha:1.0];
    subtitleLabel.textAlignment         = UITextAlignmentLeft;

    [self.contentView addSubview:subtitleLabel];
}

//----------------------------------------------------------------------------------------------------
- (void)createConnectButtons {
    googleButton = [[UIButton alloc] initWithFrame:CGRectMake(131,0,60,50)];
    
    [googleButton setBackgroundImage:[UIImage imageNamed:kImgGoogleOff]
                            forState:UIControlStateNormal];
    
    [googleButton setBackgroundImage:[UIImage imageNamed:kImgGoogleOn]
                            forState:UIControlStateHighlighted];
    
    [googleButton setBackgroundImage:[UIImage imageNamed:kImgGoogleDisabled]
                            forState:UIControlStateDisabled];
    
    [googleButton addTarget:self
                     action:@selector(didTapGoogleButton:)
           forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:googleButton];
    
    
    
    yahooButton = [[UIButton alloc] initWithFrame:CGRectMake(250,0,59,50)];
    
    [yahooButton setBackgroundImage:[UIImage imageNamed:kImgYahooOff]
                            forState:UIControlStateNormal];
    
    [yahooButton setBackgroundImage:[UIImage imageNamed:kImgYahooOn]
                            forState:UIControlStateHighlighted];
    
    [yahooButton setBackgroundImage:[UIImage imageNamed:kImgYahooDisabled]
                           forState:UIControlStateDisabled];
    
    [yahooButton addTarget:self
                    action:@selector(didTapYahooButton:)
           forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:yahooButton];
    
    
    
    hotmailButton = [[UIButton alloc] initWithFrame:CGRectMake(191,0,59,50)];
    
    [hotmailButton setBackgroundImage:[UIImage imageNamed:kImgHotmailOff]
                           forState:UIControlStateNormal];
    
    [hotmailButton setBackgroundImage:[UIImage imageNamed:kImgHotmailOn]
                           forState:UIControlStateHighlighted];
    
    [hotmailButton setBackgroundImage:[UIImage imageNamed:kImgHotmailDisabled]
                             forState:UIControlStateDisabled];
    
    [hotmailButton addTarget:self
                    action:@selector(didTapHotmailButton:)
          forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:hotmailButton];
}

//----------------------------------------------------------------------------------------------------
- (void)setTitle:(NSString*)title
     andSubtitle:(NSString*)subtitle {
    
    titleLabel.text     = title;
    subtitleLabel.text  = subtitle;    
}

//----------------------------------------------------------------------------------------------------
- (void)updateConnectStatusForGoogle:(BOOL)google
                               yahoo:(BOOL)yahoo
                             hotmail:(BOOL)hotmail {
    
    googleButton.enabled = !google;
    yahooButton.enabled = !yahoo;
    hotmailButton.enabled = !hotmail;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UI events

//----------------------------------------------------------------------------------------------------
- (void)didTapGoogleButton:(UIButton*)button {
    [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Google Auth Initiated"];
    
    [self.delegate googleConnectClicked];
}

//----------------------------------------------------------------------------------------------------
- (void)didTapYahooButton:(UIButton*)button {
    [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Yahoo Auth Initiated"];
    
    [self.delegate yahooConnectClicked];
}

//----------------------------------------------------------------------------------------------------
- (void)didTapHotmailButton:(UIButton*)button {
    [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Hotmail Auth Initiated"];
    
    [self.delegate hotmailConnectClicked];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Static methods

//----------------------------------------------------------------------------------------------------
+ (NSInteger)heightForCell {
    return kEmailConnectCellHeight;
}


@end
