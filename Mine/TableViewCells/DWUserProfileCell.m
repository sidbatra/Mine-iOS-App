//
//  DWUserProfileCell.m
//  Mine
//
//  Created by Siddharth Batra on 9/4/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWUserProfileCell.h"
#import <QuartzCore/QuartzCore.h>

NSInteger const kUserPurchaseCellHeight = 84;

static const NSInteger kBylineWidth = 298;
#define kBylineFont [UIFont fontWithName:@"HelveticaNeue" size:14]


@interface DWUserProfileCell() {
    UIImageView     *userImageView;
    UILabel         *userNameLabel;
    UILabel         *bylineLabel;
}

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUserProfileCell

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
        
		self.selectionStyle = UITableViewCellSelectionStyleNone;	
	}
	
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)resetUI {
    userImageView.image = nil;
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
- (void)setUserImage:(UIImage*)image {
    userImageView.image = image;
}

//----------------------------------------------------------------------------------------------------
- (void)setUserName:(NSString*)userName {
    userNameLabel.text = userName;
}

//----------------------------------------------------------------------------------------------------
- (void)setByline:(NSString*)byline {

    CGRect frame = bylineLabel.frame;
    frame.size.width = kBylineWidth;
    bylineLabel.frame = frame;
    
    bylineLabel.text = byline;
    [bylineLabel sizeToFit];

}

//----------------------------------------------------------------------------------------------------
+ (NSInteger)heightForCellWithByline:(NSString*)byline {
    NSInteger height = kUserPurchaseCellHeight;
    
    if(byline && byline.length)
        height += [byline sizeWithFont:kBylineFont 
                     constrainedToSize:CGSizeMake(kBylineWidth,1000)
                              lineBreakMode:UILineBreakModeWordWrap].height;
    return  height;
}


@end
