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
static NSString* const kImgSeparator = @"profile-followings-divider.png";

#define kBylineFont [UIFont fontWithName:@"HelveticaNeue" size:14]


@interface DWUserProfileCell() {
    UIImageView     *userImageView;
    UIImageView     *separatorImageView;
    
    UILabel         *userNameLabel;
    UILabel         *purchasesCountLabel;
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
        self.contentView.backgroundColor = [UIColor colorWithRed:0.223 green:0.223 blue:0.223 alpha:1.0];
        
        //[self createBorders];
        [self createUserImageView];
        [self createUserNameLabel];
        [self createPurchasesLabel];
        [self createBylineLabel];
        [self createSeparatorImage];
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
    userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(11,11,48,48)];
    userImageView.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    userImageView.layer.cornerRadius = 3;
    userImageView.layer.masksToBounds = YES;
    
    [self.contentView addSubview:userImageView];
}

//----------------------------------------------------------------------------------------------------
- (void)createUserNameLabel {
    userNameLabel  = [[UILabel alloc] initWithFrame:CGRectMake(68,10,240,32)];
    
    userNameLabel.backgroundColor    = [UIColor clearColor];
    userNameLabel.adjustsFontSizeToFitWidth = NO;
    userNameLabel.font               = [UIFont fontWithName:@"HelveticaNeue-Bold" size:24];
    userNameLabel.textColor          = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    userNameLabel.textAlignment      = UITextAlignmentLeft;
    //userNameLabel.layer.shadowColor  = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0].CGColor;
    //userNameLabel.layer.shadowOffset = CGSizeMake(0,-1);
    //userNameLabel.layer.shadowRadius = 0;
    //userNameLabel.layer.shadowOpacity = 1.0;
    
    [self.contentView addSubview:userNameLabel];
}

//----------------------------------------------------------------------------------------------------
- (void)createPurchasesLabel {
    purchasesCountLabel  = [[UILabel alloc] initWithFrame:CGRectMake(68,40,240,20)];
    
    purchasesCountLabel.backgroundColor    = [UIColor clearColor];
    purchasesCountLabel.font               = [UIFont fontWithName:@"HelveticaNeue" size:14];
    purchasesCountLabel.textColor          = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0];
    purchasesCountLabel.textAlignment      = UITextAlignmentLeft;
    //purchasesCountLabel.layer.shadowColor  = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0].CGColor;
    //purchasesCountLabel.layer.shadowOffset = CGSizeMake(0,1);
    //purchasesCountLabel.layer.shadowRadius = 0;
    //purchasesCountLabel.layer.shadowOpacity = 1.0;
    
    [self.contentView addSubview:purchasesCountLabel];
}

//----------------------------------------------------------------------------------------------------
- (void)createBylineLabel {
    bylineLabel = [[UILabel alloc] initWithFrame:CGRectMake(11, 
                                                            userImageView.frame.origin.y + userImageView.frame.size.height + 9,
                                                            kBylineWidth,
                                                            1)];
    bylineLabel.backgroundColor    = [UIColor clearColor];
    bylineLabel.font               = kBylineFont;
    bylineLabel.textColor          = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0];
    bylineLabel.textAlignment      = UITextAlignmentLeft;
    bylineLabel.numberOfLines      = 0;
    bylineLabel.lineBreakMode      = UILineBreakModeWordWrap;
    
    [self.contentView addSubview:bylineLabel];
}

//----------------------------------------------------------------------------------------------------
- (void)createConnectionButtons {
    
    followingButton = [[UIButton alloc] initWithFrame:CGRectMake(11,0,149,44)];
    
    [followingButton addTarget:self
                        action:@selector(didTapFollowingButton:)
              forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:followingButton];
    
    
    
    followersButton = [[UIButton alloc] initWithFrame:CGRectMake(163,0,149,44)];

    [followersButton addTarget:self
                        action:@selector(didTapFollowersButton:)
              forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:followersButton];

}

//----------------------------------------------------------------------------------------------------
- (void)createSeparatorImage {
    separatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(11, 0, 298, 38)];
    separatorImageView.image = [UIImage imageNamed:kImgSeparator];
    
    [self.contentView addSubview:separatorImageView];
}

//----------------------------------------------------------------------------------------------------
- (void)createConnectionLabels {
    followingLabel = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(0,0,149,44)];
    followingLabel.textAlignment = UITextAlignmentLeft;
    followingLabel.centerVertically = YES;
    followingLabel.automaticallyAddLinksForType = 0;
    followingLabel.backgroundColor = [UIColor clearColor];
    //followingLabel.layer.shadowColor  = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0].CGColor;
    //followingLabel.layer.shadowOffset = CGSizeMake(0,1);
    //followingLabel.layer.shadowRadius = 0;
    //followingLabel.layer.shadowOpacity = 1.0;
    
    [self.contentView addSubview:followingLabel];
    
    
    followersLabel = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(0,0,149,44)];
    followersLabel.textAlignment = UITextAlignmentLeft;
    followersLabel.centerVertically = YES;
    followersLabel.automaticallyAddLinksForType = 0;
    followersLabel.backgroundColor = [UIColor clearColor];
    //followersLabel.layer.shadowColor  = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0].CGColor;
    //followersLabel.layer.shadowOffset = CGSizeMake(0,1);
    //followersLabel.layer.shadowRadius = 0;
    //followersLabel.layer.shadowOpacity = 1.0;
    
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
   purchasesCount:(NSInteger)purchasesCount
  followingsCount:(NSInteger)followingsCount
   followersCount:(NSInteger)followersCount {
    
    
    purchasesCountLabel.text = [NSString stringWithFormat:@"%d %@",purchasesCount,purchasesCount == 1 ? @"item" : @"items"];
    

    CGRect frame = bylineLabel.frame;
    frame.size.width = kBylineWidth;
    bylineLabel.frame = frame;
    bylineLabel.text = byline;
    [bylineLabel sizeToFit];
    
    
    frame = separatorImageView.frame;
    frame.origin.y = bylineLabel.frame.origin.y + bylineLabel.frame.size.height + 8;
    separatorImageView.frame = frame;
    
    
    frame = followingButton.frame;
    frame.origin.y = separatorImageView.frame.origin.y + 1;
    followingButton.frame = frame;
    
    frame = followingButton.frame;
    frame.origin.x += 10;
    frame.origin.y -= 2;
    followingLabel.frame = frame;
    
    
    NSString *followingCountString = [NSString stringWithFormat:@"%d",followingsCount];
    NSString *followingText = [NSString stringWithFormat:@"%@ FOLLOWING",followingCountString];
    
    NSRange countRange = NSMakeRange(0,followingCountString.length+1);
    
    NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:followingText];
    [attrStr setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:11]];
    [attrStr setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:25] range:countRange];
    [attrStr setTextColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0]];
    
    followingLabel.attributedText = attrStr;
    

    frame = followersButton.frame;
    frame.origin.y = separatorImageView.frame.origin.y + 1;
    followersButton.frame = frame; 
    
    
    frame = followersButton.frame;
    frame.origin.x += 10;
    frame.origin.y -= 2;
    followersLabel.frame = frame;
    
    
    NSString *followersCountString = [NSString stringWithFormat:@"%d",followersCount];
    NSString *followersText = [NSString stringWithFormat:@"%@ %@",followersCountString,followersCount == 1 ? @"FOLLOWER" : @"FOLLOWERS"];
    
    countRange = NSMakeRange(0,followersCountString.length+1);
    
    attrStr = [NSMutableAttributedString attributedStringWithString:followersText];
    [attrStr setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:11]];
    [attrStr setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:25] range:countRange];
    [attrStr setTextColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0]];
    
    followersLabel.attributedText = attrStr;
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
    
    height += 36;
        
    return  height;
}



@end
