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

static NSString* const kImgGoogleOff    = @"feed-btn-gmail-off.png";
static NSString* const kImgGoogleOn     = @"feed-btn-gmail-on.png";
static NSString* const kImgYahooOff     = @"feed-btn-yahoo-off.png";
static NSString* const kImgYahooOn      = @"feed-btn-yahoo-on.png";
static NSString* const kImgHotmailOff   = @"feed-btn-yahoo-off.png";
static NSString* const kImgHotmailOn    = @"feed-btn-yahoo-on.png";


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
        self.contentView.backgroundColor = [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1.0];
        
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
    bottomBorder.backgroundColor = [UIColor colorWithRed:0.862 green:0.862 blue:0.862 alpha:1.0];
    
    [self.contentView addSubview:bottomBorder];
}

//----------------------------------------------------------------------------------------------------
- (void)createTitleLabel {
    titleLabel  = [[UILabel alloc] initWithFrame:CGRectMake(11,2,180,30)];
    
    titleLabel.backgroundColor      = [UIColor clearColor];
    titleLabel.font                 = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
    titleLabel.textColor            = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    titleLabel.textAlignment        = UITextAlignmentLeft;
    
    [self.contentView addSubview:titleLabel];
}

//----------------------------------------------------------------------------------------------------
- (void)createSubtitleLabel {
    subtitleLabel  = [[UILabel alloc] initWithFrame:CGRectMake(11,22,158,24)];
    
    subtitleLabel.backgroundColor       = [UIColor clearColor];
    subtitleLabel.font                  = [UIFont fontWithName:@"HelveticaNeue" size:11];
    subtitleLabel.textColor             = [UIColor colorWithRed:0.5372 green:0.5372 blue:0.5372 alpha:1.0];
    subtitleLabel.textAlignment         = UITextAlignmentLeft;

    [self.contentView addSubview:subtitleLabel];
}

//----------------------------------------------------------------------------------------------------
- (void)createConnectButtons {
    googleButton = [[UIButton alloc] initWithFrame:CGRectMake(196,0,56,50)];
    
    [googleButton setBackgroundImage:[UIImage imageNamed:kImgGoogleOff]
                            forState:UIControlStateNormal];
    
    [googleButton setBackgroundImage:[UIImage imageNamed:kImgGoogleOn]
                            forState:UIControlStateHighlighted];
    
    [googleButton addTarget:self
                     action:@selector(didTapGoogleButton:)
           forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:googleButton];
    
    
    
    yahooButton = [[UIButton alloc] initWithFrame:CGRectMake(252,0,55,50)];
    
    [yahooButton setBackgroundImage:[UIImage imageNamed:kImgYahooOff]
                            forState:UIControlStateNormal];
    
    [yahooButton setBackgroundImage:[UIImage imageNamed:kImgYahooOn]
                            forState:UIControlStateHighlighted];
    
    [yahooButton addTarget:self
                    action:@selector(didTapYahooButton:)
           forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:yahooButton];
    
    
    
    hotmailButton = [[UIButton alloc] initWithFrame:CGRectMake(307,0,55,50)];
    
    [hotmailButton setBackgroundImage:[UIImage imageNamed:kImgHotmailOff]
                           forState:UIControlStateNormal];
    
    [hotmailButton setBackgroundImage:[UIImage imageNamed:kImgHotmailOn]
                           forState:UIControlStateHighlighted];
    
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
