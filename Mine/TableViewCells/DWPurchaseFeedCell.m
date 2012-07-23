//
//  DWPurchaseFeedCell.m
//  Mine
//
//  Created by Siddharth Batra on 7/22/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWPurchaseFeedCell.h"

NSInteger const kPurchaseFeedCellHeight = 30;


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
		[self createMessageLabel];
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;	
	}
	
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)createMessageLabel {
    messageLabel					= [[UILabel alloc] initWithFrame:CGRectMake(20,-1,
                                                                                self.contentView.frame.size.width-40,
                                                                                kPurchaseFeedCellHeight)];
    messageLabel.font				= [UIFont fontWithName:@"HelveticaNeue" size:13];	
    messageLabel.textColor			= [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.25];
    messageLabel.backgroundColor	= [UIColor clearColor];
    messageLabel.textAlignment		= UITextAlignmentCenter;
    
    [self.contentView addSubview:messageLabel];
}

//----------------------------------------------------------------------------------------------------
- (void)setMessage:(NSString*)message {
    messageLabel.text = message;
}

@end
