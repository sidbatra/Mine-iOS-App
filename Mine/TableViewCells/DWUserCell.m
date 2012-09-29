//
//  DWUserCell.m
//  Mine
//
//  Created by Siddharth Batra on 8/2/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWUserCell.h"
#import <QuartzCore/QuartzCore.h>

NSInteger const kUserCellHeight = 51;



@interface DWUserCell() {
    UIImageView *userImageView;
    UILabel  *userNameLabel;
    
    UILabel *bottomBorder;
    
    DWFollowButton *followButton;
    
    BOOL _highlighted;
}

@property (nonatomic,assign) BOOL highlighted;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUserCell

@synthesize userID      = _userID;
@synthesize highlighted = _highlighted;
@synthesize delegate    = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)initWithStyle:(UITableViewCellStyle)style 
	reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style
				reuseIdentifier:reuseIdentifier];
	
    if (self) {        
        self.contentView.backgroundColor = [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1.0];
        
        [self createBorders];
        [self createUserImageView];
        [self createUserNameLabel];
        [self createFollowButton];
        
		self.selectionStyle = UITableViewCellSelectionStyleBlue;	
	}
	
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)resetUI {
    userImageView.image = nil;
    followButton.hidden = NO;
}

//----------------------------------------------------------------------------------------------------
- (void)displayActiveFollowing {
    [followButton enterActiveState];
}

//----------------------------------------------------------------------------------------------------
- (void)displayInactiveFollowing {
    [followButton enterInactiveState];
}

//----------------------------------------------------------------------------------------------------
- (void)createBorders {
    //UILabel *topBorder = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width,1)];
    //topBorder.backgroundColor = [UIColor colorWithRed:0.972 green:0.972 blue:0.972 alpha:1.0];

    //[self.contentView addSubview:topBorder];
    
    
    bottomBorder = [[UILabel alloc] initWithFrame:CGRectMake(0, kUserCellHeight-1, self.contentView.frame.size.width,1)];
    bottomBorder.backgroundColor = [UIColor colorWithRed:0.862 green:0.862 blue:0.862 alpha:1.0];
    
    [self.contentView addSubview:bottomBorder];
}

//----------------------------------------------------------------------------------------------------
- (void)createUserImageView {
    userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,50,50)];
    userImageView.backgroundColor = [UIColor colorWithRed:0.862 green:0.862 blue:0.862 alpha:1.0];
    //userImageView.layer.cornerRadius = 3;
    //userImageView.layer.masksToBounds = YES;
    
    [self.contentView addSubview:userImageView];
}

//----------------------------------------------------------------------------------------------------
- (void)createUserNameLabel {
    userNameLabel  = [[UILabel alloc] initWithFrame:CGRectMake(60,10,158,30)];
    
    userNameLabel.backgroundColor    = [UIColor clearColor];
    userNameLabel.font               = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
    userNameLabel.textColor          = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    userNameLabel.highlightedTextColor  = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    userNameLabel.textAlignment      = UITextAlignmentLeft;
    //userNameLabel.layer.shadowColor  = [UIColor colorWithRed:0.972 green:0.972 blue:0.972 alpha:1.0].CGColor;
    //userNameLabel.layer.shadowOffset = CGSizeMake(0,1);
    //userNameLabel.layer.shadowRadius = 0;
    //userNameLabel.layer.shadowOpacity = 1.0;
    
    [self.contentView addSubview:userNameLabel];
}

//----------------------------------------------------------------------------------------------------
- (void)createFollowButton {
    followButton = [[DWFollowButton alloc] initWithFrame:CGRectMake(224,12,83,25) followButtonStyle:kFollowButonStyleLight];
    followButton.delegate = self;
    
    [self.contentView addSubview:followButton];
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
- (void)hideFollowButton {
    followButton.hidden = YES;
}


//----------------------------------------------------------------------------------------------------
- (void)setHighlighted:(BOOL)highlighted
			  animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
	
     if(highlighted && !self.highlighted) {
         self.highlighted = YES;
         bottomBorder.backgroundColor = [UIColor colorWithRed:0.862 green:0.862 blue:0.862 alpha:1.0];
     }
     else if(!highlighted && self.highlighted) {
         self.highlighted = NO;
     }
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWFollowButtonDelegate

//----------------------------------------------------------------------------------------------------
- (void)followButtonClicked {
    [self.delegate userCellFollowClickedForUserID:self.userID];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Static methods

//----------------------------------------------------------------------------------------------------
+ (NSInteger)heightForCell {
    return kUserCellHeight;
}


@end
