//
//  DWUserProfileCell.m
//  Mine
//
//  Created by Siddharth Batra on 9/4/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWUserProfileCell.h"

#import <QuartzCore/QuartzCore.h>
#import "OHAttributedLabel.h"
#import "NSAttributedString+Attributes.h"


NSInteger const kUserPurchaseCellHeight = 84;

static NSInteger const kBylineWidth = 298;
static NSString* const kImgActionButtonBg = @"btn-action-bg-dark.png";

#define kBylineFont [UIFont fontWithName:@"HelveticaNeue" size:14]


@interface DWUserProfileCell() {
    UIImageView     *userImageView;
    UILabel         *userNameLabel;
    UILabel         *bylineLabel;
    
    UIButton        *followingButton;
    UIButton        *followersButton;
    
    OHAttributedLabel   *followingLabel;
    OHAttributedLabel   *followersLabel;
}

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUserProfileCell

@synthesize delegate = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)initWithStyle:(UITableViewCellStyle)style 
	reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style
				reuseIdentifier:reuseIdentifier];
	
    if (self) {        
        self.contentView.backgroundColor = [UIColor colorWithRed:0.270 green:0.270 blue:0.270 alpha:1.0];
        
        //[self createBorders];
        [self createUserImageView];
        [self createUserNameLabel];
        [self createBylineLabel];
        [self createConnectionButtons];
        [self createConnectionLabels];
        
		self.selectionStyle = UITableViewCellSelectionStyleNone;	
	}
	
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)resetUI {
    userImageView.image = nil;
    followingButton.hidden = NO;
    followersButton.hidden = NO;
}

//----------------------------------------------------------------------------------------------------
- (void)createBorders {
    UILabel *topBorder = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width,1)];
    topBorder.backgroundColor = [UIColor colorWithRed:0.972 green:0.972 blue:0.972 alpha:1.0];
    
    [self.contentView addSubview:topBorder];
    
    
    UILabel *bottomBorder = [[UILabel alloc] initWithFrame:CGRectMake(0, kUserPurchaseCellHeight-1, self.contentView.frame.size.width,1)];
    bottomBorder.backgroundColor = [UIColor colorWithRed:0.839 green:0.839 blue:0.839 alpha:1.0];
    
    [self.contentView addSubview:bottomBorder];
}

//----------------------------------------------------------------------------------------------------
- (void)createUserImageView {
    userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(11,9,48,48)];
    userImageView.backgroundColor = [UIColor clearColor];
    userImageView.layer.cornerRadius = 3;
    userImageView.layer.masksToBounds = YES;
    
    [self.contentView addSubview:userImageView];
}

//----------------------------------------------------------------------------------------------------
- (void)createUserNameLabel {
    userNameLabel  = [[UILabel alloc] initWithFrame:CGRectMake(68,10,240,32)];
    
    userNameLabel.backgroundColor    = [UIColor clearColor];
    userNameLabel.font               = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    userNameLabel.textColor          = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    userNameLabel.textAlignment      = UITextAlignmentLeft;
    userNameLabel.layer.shadowColor  = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0].CGColor;
    userNameLabel.layer.shadowOffset = CGSizeMake(0,1);
    userNameLabel.layer.shadowRadius = 0;
    userNameLabel.layer.shadowOpacity = 1.0;
    
    [self.contentView addSubview:userNameLabel];
}

//----------------------------------------------------------------------------------------------------
- (void)createBylineLabel {
    bylineLabel = [[UILabel alloc] initWithFrame:CGRectMake(11, 
                                                            userImageView.frame.origin.y + userImageView.frame.size.height + 10,
                                                            kBylineWidth,
                                                            1)];
    bylineLabel.backgroundColor    = [UIColor clearColor];
    bylineLabel.font               = kBylineFont;
    bylineLabel.textColor          = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    bylineLabel.textAlignment      = UITextAlignmentLeft;
    bylineLabel.numberOfLines      = 0;
    bylineLabel.lineBreakMode      = UILineBreakModeWordWrap;
    
    [self.contentView addSubview:bylineLabel];
}

//----------------------------------------------------------------------------------------------------
- (void)createConnectionButtons {
    
    followingButton = [[UIButton alloc] initWithFrame:CGRectMake(11,0,149,44)];
    
    [followingButton setBackgroundImage:[UIImage imageNamed:kImgActionButtonBg]
                                                   forState:UIControlStateNormal];
    
    [followingButton addTarget:self
                        action:@selector(didTapFollowingButton:)
              forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:followingButton];
    
    
    
    followersButton = [[UIButton alloc] initWithFrame:CGRectMake(163,0,149,44)];
    
    [followersButton setBackgroundImage:[UIImage imageNamed:kImgActionButtonBg]
                               forState:UIControlStateNormal];

    [followersButton addTarget:self
                        action:@selector(didTapFollowersButton:)
              forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:followersButton];

}

//----------------------------------------------------------------------------------------------------
- (void)createConnectionLabels {
    followingLabel = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(0,0,149,44)];
    followingLabel.textAlignment = UITextAlignmentLeft;
    followingLabel.centerVertically = YES;
    followingLabel.automaticallyAddLinksForType = 0;
    followingLabel.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:followingLabel];
    
    
    followersLabel = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(0,0,149,44)];
    followersLabel.textAlignment = UITextAlignmentLeft;
    followersLabel.centerVertically = YES;
    followersLabel.automaticallyAddLinksForType = 0;
    followersLabel.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:followersLabel];

}

//----------------------------------------------------------------------------------------------------
- (void)setUserImage:(UIImage*)image {
    userImageView.image = image;
}

//----------------------------------------------------------------------------------------------------
- (void)setUserName:(NSString*)userName {
    userNameLabel.text = userName;
}

//----------------------------------------------------------------------------------------------------
- (void)setByline:(NSString*)byline 
  followingsCount:(NSInteger)followingsCount
   followersCount:(NSInteger)followersCount {

    CGRect frame = bylineLabel.frame;
    frame.size.width = kBylineWidth;
    bylineLabel.frame = frame;
    bylineLabel.text = byline;
    [bylineLabel sizeToFit];
    
    
    if(followingsCount) {
        frame = followingButton.frame;
        frame.origin.y = bylineLabel.frame.origin.y+bylineLabel.frame.size.height+11;
        followingButton.frame = frame;
        
        frame = followingButton.frame;
        frame.origin.x += 10;
        frame.origin.y -= 2;
        followingLabel.frame = frame;
        
        
        NSString *followingCountString = [NSString stringWithFormat:@"%d",followingsCount];
        NSString *followingText = [NSString stringWithFormat:@"%@ following",followingCountString];
        
        NSRange countRange = NSMakeRange(0,followingCountString.length);
        
        NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:followingText];
        [attrStr setFont:[UIFont fontWithName:@"HelveticaNeue" size:13.5]];
        [attrStr setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20] range:countRange];
        [attrStr setTextColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0]];
        
        followingLabel.attributedText = attrStr;
    }
    else {
        followingButton.hidden = YES;
        
        frame = followersButton.frame;
        frame.origin.x = followingButton.frame.origin.x;
        followersButton.frame = frame;
    }
    
    
    if(followersCount) {
        frame = followersButton.frame;
        frame.origin.y = bylineLabel.frame.origin.y+bylineLabel.frame.size.height+11;
        followersButton.frame = frame; 
        
        
        frame = followersButton.frame;
        frame.origin.x += 10;
        frame.origin.y -= 2;
        followersLabel.frame = frame;
        
        
        NSString *followersCountString = [NSString stringWithFormat:@"%d",followersCount];
        NSString *followersText = [NSString stringWithFormat:@"%@ %@",followersCountString,followersCount > 1 ? @"followers" : @"follower"];
        
        NSRange countRange = NSMakeRange(0,followersCountString.length);
        
        NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:followersText];
        [attrStr setFont:[UIFont fontWithName:@"HelveticaNeue" size:13.5]];
        [attrStr setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20] range:countRange];
        [attrStr setTextColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0]];
        
        followersLabel.attributedText = attrStr;
    }
    else {
        followersButton.hidden = YES;
    }
}




//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UI Events

//----------------------------------------------------------------------------------------------------
- (void)didTapFollowingButton:(UIButton*)button {
    [self.delegate followingButtonClicked];
}

//----------------------------------------------------------------------------------------------------
- (void)didTapFollowersButton:(UIButton*)button {
    [self.delegate followersButtonClicked];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Static methods

//----------------------------------------------------------------------------------------------------
+ (NSInteger)heightForCellWithByline:(NSString*)byline 
                    connectionsCount:(NSInteger)connectionsCount {
    
    NSInteger height = kUserPurchaseCellHeight;
    
    if(byline && byline.length)
        height += [byline sizeWithFont:kBylineFont 
                     constrainedToSize:CGSizeMake(kBylineWidth,1000)
                              lineBreakMode:UILineBreakModeWordWrap].height;
    
    if(connectionsCount)
        height += 55;
        
    return  height;
}



@end
