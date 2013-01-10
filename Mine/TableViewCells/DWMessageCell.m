//
//  DWMessageCell.m
//  Mine
//
//  Created by Siddharth Batra on 1/9/13.
//  Copyright (c) 2013 Denwen, Inc. All rights reserved.
//

#import "DWMessageCell.h"

@interface DWMessageCell() {
    UILabel         *messageLabel;
    //UIImageView     *borderImageView;
}
@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWMessageCell

//----------------------------------------------------------------------------------------------------
- (id)initWithStyle:(UITableViewCellStyle)style
	reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style
				reuseIdentifier:reuseIdentifier];
	
    if (self) {
        self.contentView.clipsToBounds = YES;
		self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.contentView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        
        [self createMessageLabel];
        //[self createBorderImageView];
	}
	
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)createMessageLabel {
    messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,20,self.frame.size.width,30)];
    
    messageLabel.numberOfLines        = 1;
    messageLabel.backgroundColor      = [UIColor clearColor];
    messageLabel.font                 = [UIFont fontWithName:@"HelveticaNeue" size:13];
    messageLabel.textColor            = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0];
    messageLabel.textAlignment        = UITextAlignmentCenter;
    
    [self.contentView addSubview:messageLabel];
}

//----------------------------------------------------------------------------------------------------
- (void)createBorderImageView {
    //borderImageView         = [[UIImageView alloc] initWithFrame:CGRectMake(0, 42, 320, 1)];
    //borderImageView.image   = [UIImage imageNamed:kImgBorder];
    
    //[self.contentView addSubview:borderImageView];
}

//----------------------------------------------------------------------------------------------------
- (void)setMessage:(NSString *)message {
    messageLabel.text = message;
}

//----------------------------------------------------------------------------------------------------
+ (NSInteger)height {
    return 60;
}

@end