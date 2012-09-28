//
//  DWCommentCell.m
//  Mine
//
//  Created by Siddharth Batra on 7/30/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWCommentCell.h"

#import <QuartzCore/QuartzCore.h>
#import "NSAttributedString+Attributes.h"

static NSString* const kUserURLScheme   = @"user";

static NSInteger const kCommentCellHeight = 20;
static NSInteger const kCommentWidth = 250;
static NSInteger const kUserImageSide = 32;

#define kCommentFont [UIFont fontWithName:@"HelveticaNeue" size:14]


@interface DWCommentCell() {
    UIButton    *userImageButton;
    
    OHAttributedLabel   *messageLabel;
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
        self.contentView.backgroundColor = [UIColor clearColor];
        self.contentView.clipsToBounds = YES;
        
        [self createUserImageButton];
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
    userImageButton  = [[UIButton alloc] initWithFrame:CGRectMake(10,10,kUserImageSide,kUserImageSide)];
    
     userImageButton.imageView.layer.cornerRadius = 2;
    
    [userImageButton addTarget:self
                        action:@selector(didTapUserImageButton:)
              forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:userImageButton];
}

//----------------------------------------------------------------------------------------------------
- (void)createMessageLabel {
    
    messageLabel =  [[OHAttributedLabel alloc] initWithFrame:CGRectMake(userImageButton.frame.origin.y + userImageButton.frame.size.width + 9, 
                                                        10,
                                                        kCommentWidth,
                                                        0)];
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.automaticallyAddLinksForType = 0;
    messageLabel.linkColor = [UIColor colorWithRed:0.090 green:0.435 blue:0.627 alpha:1.0];
    messageLabel.underlineLinks = NO;
    messageLabel.delegate = self;
    
    [self.contentView addSubview:messageLabel];
}

//----------------------------------------------------------------------------------------------------
- (void)setUserImage:(UIImage*)image {
    [userImageButton setImage:image
                     forState:UIControlStateNormal];
}

//----------------------------------------------------------------------------------------------------
- (void)setMessage:(NSString*)message userName:(NSString*)userName {
    
    NSString *commentText = [NSString stringWithFormat:@"%@: %@",userName,message];
        
    NSRange nameRange = NSMakeRange(0,userName.length);
    
	NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:commentText];
    
	[attrStr setFont:kCommentFont];
	[attrStr setTextColor:[UIColor colorWithRed:0.333 green:0.333 blue:0.333 alpha:1.0]];
    [attrStr setTextAlignment:UITextAlignmentLeft lineBreakMode:UILineBreakModeWordWrap lineHeight:2];
    
	[attrStr setTextBold:YES range:NSMakeRange(0,userName.length+1)];
    
    CGRect frame = messageLabel.frame;
    frame.size.height = 0;
    frame.size.width = kCommentWidth;
    messageLabel.frame = frame;
    
    messageLabel.attributedText = attrStr;
    [messageLabel sizeToFit];
    
    [messageLabel addCustomLink:[NSURL URLWithString:kUserURLScheme]
                               inRange:nameRange];
}

//----------------------------------------------------------------------------------------------------
+ (NSInteger)heightForCellWithMessage:(NSString*)message userName:(NSString*)userName {
    
    NSInteger textHeight = [[NSString stringWithFormat:@"%@: %@",userName,message] sizeWithFont:kCommentFont 
                                                                                                   constrainedToSize:CGSizeMake(kCommentWidth,1500)
                                                                                                       lineBreakMode:UILineBreakModeWordWrap].height;
    
    return kCommentCellHeight +  MAX(kUserImageSide,textHeight);
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
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark OHAttributedLabelDelegate

//----------------------------------------------------------------------------------------------------
-(BOOL)attributedLabel:(OHAttributedLabel *)attributedLabel 
      shouldFollowLink:(NSTextCheckingResult *)linkInfo {
    
    [self userClicked];
    
    return true;
}


@end
