//
//  DWCommentCell.m
//  Mine
//
//  Created by Siddharth Batra on 7/30/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWCommentCell.h"

static NSInteger const kCommentCellHeight = 150;


@interface DWCommentCell() {
    UIButton    *userImageButton;
    UIButton    *userNameButton;
    
    UILabel     *messageLabel;
}


/**
 * Fires the delegate event after a user element is clicked.
 */
- (void)userClicked;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWCommentCell

@synthesize commentID   = _commentID;
@synthesize delegate    = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)initWithStyle:(UITableViewCellStyle)style 
	reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style
				reuseIdentifier:reuseIdentifier];
	
    if (self) {
        self.contentView.clipsToBounds = YES;
        
        [self createUserImageButton];
        [self createUserNameButton];
        [self createMessageLabel];
        
		self.selectionStyle = UITableViewCellSelectionStyleNone;	
	}
	
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)userClicked {  
    
    SEL sel = @selector(userClickedForCommentID:);
    
    [self.delegate performSelector:sel
                        withObject:[NSNumber numberWithInteger:self.commentID]];
}

//----------------------------------------------------------------------------------------------------
- (void)createUserImageButton {
    userImageButton  = [[UIButton alloc] initWithFrame:CGRectMake(0,0,50,50)];
    
    [userImageButton addTarget:self
                        action:@selector(didTapUserImageButton:)
              forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:userImageButton];
}

//----------------------------------------------------------------------------------------------------
- (void)createUserNameButton {
    userNameButton  = [[UIButton alloc] initWithFrame:CGRectMake(55,0,self.contentView.frame.size.width-10,50)];
    userNameButton.backgroundColor = [UIColor redColor];
    
    userNameButton.titleLabel.font               = [UIFont fontWithName:@"HelveticaNeue" size:13];
    userNameButton.titleLabel.textColor          = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    userNameButton.titleLabel.textAlignment      = UITextAlignmentLeft;
    
    [userNameButton addTarget:self
                       action:@selector(didTapUserNameButton:)
             forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:userNameButton];
}

//----------------------------------------------------------------------------------------------------
- (void)createMessageLabel {
    messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                             55,
                                                             self.contentView.frame.size.width - 10,
                                                             60)];
    messageLabel.numberOfLines       = 0;
    messageLabel.backgroundColor     = [UIColor greenColor];
    messageLabel.font                = [UIFont fontWithName:@"HelveticaNeue" size:13];
    messageLabel.textColor           = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    messageLabel.textAlignment       = UITextAlignmentLeft;
    
    [self.contentView addSubview:messageLabel];
}

//----------------------------------------------------------------------------------------------------
- (void)setUserImage:(UIImage*)image {
    [userImageButton setImage:image
                     forState:UIControlStateNormal];
}

//----------------------------------------------------------------------------------------------------
- (void)setUserName:(NSString*)userName {
    [userNameButton setTitle:userName
                    forState:UIControlStateNormal];
}

//----------------------------------------------------------------------------------------------------
- (void)setMessage:(NSString*)message {
    messageLabel.frame = CGRectMake(10,
                                    55,
                                    self.contentView.frame.size.width - 10,
                                    60);
    messageLabel.text = message;
    [messageLabel sizeToFit];
}

//----------------------------------------------------------------------------------------------------
+ (NSInteger)heightForCellWithMessage:(NSString*)message {
    return kCommentCellHeight;
}



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UI Events

//----------------------------------------------------------------------------------------------------
- (void)didTapUserImageButton:(UIButton*)button {
    [self userClicked];
}

//----------------------------------------------------------------------------------------------------
- (void)didTapUserNameButton:(UIButton*)button {
    [self userClicked];
}


@end
