//
//  DWPurchaseFeedCell.m
//  Mine
//
//  Created by Siddharth Batra on 7/22/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWPurchaseFeedCell.h"

NSInteger const kPurchaseFeedCellHeight = 400;


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWPurchaseFeedCell

//----------------------------------------------------------------------------------------------------
- (id)initWithStyle:(UITableViewCellStyle)style 
	reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style
				reuseIdentifier:reuseIdentifier];
	
    if (self) {
        [self createUserImageView];
        [self createPurchaseImageView];
        [self createUserNameLabel];
		[self createTitleLabel];
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;	
	}
	
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)createUserImageView {
    userImageView                   = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,50,50)];
    purchaseImageView.contentMode   = UIViewContentModeScaleAspectFit;
    userImageView.backgroundColor   = [UIColor yellowColor];
    
    [self.contentView addSubview:userImageView];
}

//----------------------------------------------------------------------------------------------------
- (void)createPurchaseImageView {
    purchaseImageView                   = [[UIImageView alloc] initWithFrame:CGRectMake(0,50,320,320)];
    purchaseImageView.contentMode       = UIViewContentModeScaleAspectFit;
    purchaseImageView.backgroundColor   = [UIColor yellowColor];
    
    [self.contentView addSubview:purchaseImageView];
}

//----------------------------------------------------------------------------------------------------
- (void)createUserNameLabel {
    userNameLabel					= [[UILabel alloc] initWithFrame:CGRectMake(55,
                                                                                5,
                                                                                250,
                                                                                30)];
    userNameLabel.font				= [UIFont fontWithName:@"HelveticaNeue" size:13];	
    userNameLabel.textColor			= [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    userNameLabel.backgroundColor	= [UIColor redColor];
    userNameLabel.textAlignment		= UITextAlignmentLeft;
    
    [self.contentView addSubview:userNameLabel];
}

//----------------------------------------------------------------------------------------------------
- (void)createTitleLabel {
    titleLabel					= [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                                                370,
                                                                                self.contentView.frame.size.width-40,
                                                                                30)];
    titleLabel.font				= [UIFont fontWithName:@"HelveticaNeue" size:13];	
    titleLabel.textColor		= [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    titleLabel.backgroundColor	= [UIColor redColor];
    titleLabel.textAlignment	= UITextAlignmentLeft;
    
    [self.contentView addSubview:titleLabel];
}


//----------------------------------------------------------------------------------------------------
- (void)setUserImage:(UIImage *)image {
    userImageView.image = image;
}

//----------------------------------------------------------------------------------------------------
- (void)setPurchaseImage:(UIImage*)image {
    purchaseImageView.image = image;
}

//----------------------------------------------------------------------------------------------------
- (void)setUserName:(NSString *)userName {
    userNameLabel.text = userName;
}

//----------------------------------------------------------------------------------------------------
- (void)setTitle:(NSString*)title {
    titleLabel.text = title;
}

@end
