//
//  DWUserCell.m
//  Mine
//
//  Created by Siddharth Batra on 8/2/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWUserCell.h"

NSInteger const kUserCellHeight = 50;



@interface DWUserCell() {
    UIImageView     *userImageView;
    UILabel         *userNameLabel;
}

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUserCell

//----------------------------------------------------------------------------------------------------
- (id)initWithStyle:(UITableViewCellStyle)style 
	reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style
				reuseIdentifier:reuseIdentifier];
	
    if (self) {        
        [self createUserImageView];
        [self createUserNameLabel];
        
		self.selectionStyle = UITableViewCellSelectionStyleBlue;	
	}
	
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)resetUI {
    userImageView.image = nil;
}

//----------------------------------------------------------------------------------------------------
- (void)createUserImageView {
    userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    
    [self.contentView addSubview:userImageView];
}

//----------------------------------------------------------------------------------------------------
- (void)createUserNameLabel {
    userNameLabel  = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, self.contentView.frame.size.width-50, 50)];
    userNameLabel.backgroundColor = [UIColor whiteColor];
    
    userNameLabel.font               = [UIFont fontWithName:@"HelveticaNeue" size:13];
    userNameLabel.textColor          = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    userNameLabel.textAlignment      = UITextAlignmentLeft;
    
    [self.contentView addSubview:userNameLabel];
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
+ (NSInteger)heightForCell {
    return kUserCellHeight;
}


@end
