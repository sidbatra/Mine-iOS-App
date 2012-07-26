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
        [self createPurchaseImageView];
		[self createMessageLabel];
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;	
	}
	
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)createPurchaseImageView {
    purchaseImageView                   = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,320)];
    purchaseImageView.contentMode       = UIViewContentModeScaleAspectFit;
    purchaseImageView.backgroundColor   = [UIColor yellowColor];
    
    [self.contentView addSubview:purchaseImageView];
}

//----------------------------------------------------------------------------------------------------
- (void)createMessageLabel {
    messageLabel					= [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                                                320,
                                                                                self.contentView.frame.size.width-40,
                                                                                30)];
    messageLabel.font				= [UIFont fontWithName:@"HelveticaNeue" size:13];	
    messageLabel.textColor			= [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    messageLabel.backgroundColor	= [UIColor redColor];
    messageLabel.textAlignment		= UITextAlignmentCenter;
    
    [self.contentView addSubview:messageLabel];
}

//----------------------------------------------------------------------------------------------------
- (void)setPurchaseImage:(UIImage*)image {
    purchaseImageView.image = image;
}

//----------------------------------------------------------------------------------------------------
- (void)setMessage:(NSString*)message {
    messageLabel.text = message;
}

@end
