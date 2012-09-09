//
//  DWInviteFriendCell.m
//  Mine
//
//  Created by Siddharth Batra on 9/9/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWInviteFriendCell.h"
#import <QuartzCore/QuartzCore.h>


static NSInteger const kInviteFriendCellHeight = 50;


@interface DWInviteFriendCell() {
    UILabel *messageLabel;
}
@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWInviteFriendCell

//----------------------------------------------------------------------------------------------------
- (id)initWithStyle:(UITableViewCellStyle)style 
	reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style
				reuseIdentifier:reuseIdentifier];
	
    if (self) {
        self.contentView.clipsToBounds = YES;
        
        [self createBorders];
        [self createMessageLabel];
        
		self.selectionStyle = UITableViewCellSelectionStyleNone;	
	}
	
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)createBorders {
    UILabel *topBorder = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width,1)];
    topBorder.backgroundColor = [UIColor colorWithRed:0.972 green:0.972 blue:0.972 alpha:1.0];
    
    [self.contentView addSubview:topBorder];
    
    
    UILabel *bottomBorder = [[UILabel alloc] initWithFrame:CGRectMake(0, kInviteFriendCellHeight-1, self.contentView.frame.size.width,1)];
    bottomBorder.backgroundColor = [UIColor colorWithRed:0.839 green:0.839 blue:0.839 alpha:1.0];
    
    [self.contentView addSubview:bottomBorder];
}

//----------------------------------------------------------------------------------------------------
- (void)createMessageLabel {
    messageLabel  = [[UILabel alloc] initWithFrame:CGRectMake(11,9,207,32)];
    
    messageLabel.backgroundColor    = [UIColor clearColor];
    messageLabel.font               = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
    messageLabel.textColor          = [UIColor colorWithRed:0.333 green:0.333 blue:0.333 alpha:1.0];
    messageLabel.highlightedTextColor  = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    messageLabel.textAlignment      = UITextAlignmentLeft;
    messageLabel.layer.shadowColor  = [UIColor colorWithRed:0.972 green:0.972 blue:0.972 alpha:1.0].CGColor;
    messageLabel.layer.shadowOffset = CGSizeMake(0,1);
    messageLabel.layer.shadowRadius = 0;
    messageLabel.layer.shadowOpacity = 1.0;
    
    [self.contentView addSubview:messageLabel];
}

//----------------------------------------------------------------------------------------------------
- (void)setMessage:(NSString*)message {
    messageLabel.text = message;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Static methods

//----------------------------------------------------------------------------------------------------
+ (NSInteger)heightForCell {
    return kInviteFriendCellHeight;
}


@end
