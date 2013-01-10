//
//  DWInviteFriendCell.m
//  Mine
//
//  Created by Siddharth Batra on 9/9/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWInviteFriendCell.h"
#import <QuartzCore/QuartzCore.h>

#import "DWConstants.h"


static NSInteger const kInviteFriendCellHeight = 51;


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
        self.contentView.backgroundColor = [UIColor colorWithRed:0.929 green:0.929 blue:0.929 alpha:1.0];
        
        [self createBorders];
        [self createMessageLabel];
        //[self createChevron];
        
		self.selectionStyle = UITableViewCellSelectionStyleBlue;	
	}
	
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)createBorders {
    //UILabel *topBorder = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width,1)];
    //topBorder.backgroundColor = [UIColor colorWithRed:0.972 green:0.972 blue:0.972 alpha:1.0];
    
    //[self.contentView addSubview:topBorder];
    
    
    UILabel *bottomBorder = [[UILabel alloc] initWithFrame:CGRectMake(0, kInviteFriendCellHeight-1, self.contentView.frame.size.width,1)];
    bottomBorder.backgroundColor = [UIColor colorWithRed:0.862 green:0.862 blue:0.862 alpha:1.0];
    
    [self.contentView addSubview:bottomBorder];
}

//----------------------------------------------------------------------------------------------------
- (void)createMessageLabel {
    messageLabel  = [[UILabel alloc] initWithFrame:CGRectMake(11,10,207,30)];
    
    messageLabel.backgroundColor    = [UIColor clearColor];
    messageLabel.font               = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
    messageLabel.textColor          = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    messageLabel.highlightedTextColor  = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    messageLabel.textAlignment      = UITextAlignmentLeft;
    //messageLabel.layer.shadowColor  = [UIColor colorWithRed:0.972 green:0.972 blue:0.972 alpha:1.0].CGColor;
    //messageLabel.layer.shadowOffset = CGSizeMake(0,1);
    //messageLabel.layer.shadowRadius = 0;
    //messageLabel.layer.shadowOpacity = 1.0;
    
    [self.contentView addSubview:messageLabel];
}

//----------------------------------------------------------------------------------------------------
- (void)createChevron {
    UIImageView *chevron = [[UIImageView alloc] initWithFrame:CGRectMake(298,18,9,13)];
    chevron.image = [UIImage imageNamed:kImgChevron];
    chevron.highlightedImage = [UIImage imageNamed:kImgChevronWhite];
    
    [self.contentView addSubview:chevron];
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
