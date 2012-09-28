//
//  DWPurchaseFeedCell.m
//  Mine
//
//  Created by Siddharth Batra on 7/22/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWPurchaseFeedCell.h"

#import <QuartzCore/QuartzCore.h>
#import "NSAttributedString+Attributes.h"

#import "DWUser.h"
#import "DWLike.h"
#import "DWComment.h"
#import "DWConstants.h"


NSInteger const kTotalLikeUserImages = 6;
NSInteger const kTotalComments = 3;

static NSString* const kImgDoinkUp      = @"doink-up-16.png";
static NSString* const kImgLikeOn       = @"feed-btn-like-on.png";
static NSString* const kImgLikeOff      = @"feed-btn-like-off.png";
static NSString* const kImgLikePushed   = @"feed-btn-like-pushed.png";
static NSString* const kImgCommentOn    = @"feed-btn-comment-on.png";
static NSString* const kImgCommentOff   = @"feed-btn-comment-off.png";
static NSString* const kImgURLOn        = @"feed-btn-explore-on.png";
static NSString* const kImgURLOff       = @"feed-btn-explore-off.png";
static NSString* const kUserURLScheme   = @"user";

static NSInteger const kPurchaseFeedCellHeight  = 224 + 16 + 16 + 11 + 8;
static NSInteger const kEndorsementWidth        = 276;
static NSInteger const kCommentWidth            = 244;
static NSInteger const kBoughtTextWidth         = 228;
static NSInteger const kUserImageSide           = 34;



#define kCommentFont [UIFont fontWithName:@"HelveticaNeue" size:13]
#define kEndorsementFont [UIFont fontWithName:@"HelveticaNeue" size:13]
#define kBoughtTextFont [UIFont fontWithName:@"HelveticaNeue" size:14]
#define kActiveColor [UIColor colorWithRed:0.090 green:0.435 blue:0.627 alpha:1.0]


@interface DWPurchaseFeedCell() {
    NSMutableArray  *_likeUserImages;
    
    NSMutableArray  *_commentUserButtons;
    NSMutableArray  *_commentMessageLabels;
        
    NSInteger       commentsBaseY;
}


/**
 * User image buttons for the likers of this purchase.
 */
@property (nonatomic,strong) NSMutableArray *likeUserImages;

/**
 * Image buttons for the comments.
 */
@property (nonatomic,strong) NSMutableArray *commentUserButtons;

/**
 * Comment message labels.
 */
@property (nonatomic,strong) NSMutableArray *commentMessageLabels;

/**
 * Fires the delegate event after a user element is clicked.
 */
- (void)userClicked:(NSInteger)userID;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWPurchaseFeedCell

@synthesize purchaseID              = _purchaseID;
@synthesize userID                  = _userID;
@synthesize likeUserImages          = _likeUserImages;
@synthesize commentUserButtons      = _commentUserButtons;
@synthesize commentMessageLabels    = _commentMessageLabels;
@synthesize isInteractive           = _isInteractive;
@synthesize delegate                = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)initWithStyle:(UITableViewCellStyle)style 
	reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style
				reuseIdentifier:reuseIdentifier];
	
    if (self) {
        self.contentView.clipsToBounds = YES;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.likeUserImages     = [NSMutableArray arrayWithCapacity:kTotalLikeUserImages];
        
        [self createPurchaseImageButton];
        
        [self createInfoBackground];
        [self createDoinkImageView];
        
        [self createUserImageButton];
        [self createBoughtLabel];
        [self createEndorsementLabel];
        
        [self createLikesBackground];
        [self createLikesCountLabel];
        [self createLikeUserImages];
        [self createLikesChevron];
        [self createAllLikesButton];
        
        [self createAllCommentsButton];
        [self createLikeButton];
        [self createCommentButton];
        [self createURLButton];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;	
	}
	
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)userClicked:(NSInteger)userID {  
    
    SEL sel = @selector(userClicked:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    [self.delegate performSelector:sel
                        withObject:[NSNumber numberWithInteger:userID]];
}

//----------------------------------------------------------------------------------------------------
- (void)fireExternalURLDelegate {
    
    SEL sel = @selector(purchaseURLClicked:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    [self.delegate performSelector:sel
                        withObject:[NSNumber numberWithInteger:self.purchaseID]];
}

//----------------------------------------------------------------------------------------------------
- (NSInteger)yValueOfBoughtArea {
    return MAX(userImageButton.frame.origin.y+userImageButton.frame.size.height,boughtLabel.frame.origin.y+boughtLabel.frame.size.height);
}

//----------------------------------------------------------------------------------------------------
- (NSInteger)yValueOfLastComment {
    
    NSInteger lastCommentY = 0;
    
    if([self.commentMessageLabels count] && [self.commentUserButtons count]) {
        OHAttributedLabel *lastMessageLabel = [self.commentMessageLabels objectAtIndex:[self.commentMessageLabels count]-1];
        UIButton *lastUserImage = [self.commentUserButtons objectAtIndex:[self.commentUserButtons count]-1];
        
        lastCommentY = MAX(lastUserImage.frame.origin.y + lastUserImage.frame.size.height, 
                               lastMessageLabel.frame.origin.y + lastMessageLabel.frame.size.height);
    }

    return lastCommentY;
}

//----------------------------------------------------------------------------------------------------
- (NSInteger)yValueOfCellWithLastComment:(BOOL)withLastComment 
                        withAllCommentsButton:(BOOL)withAllCommentsButton  {
    
    NSInteger baseY = 0;
    
    if(withAllCommentsButton && !allCommentsButton.hidden) {
        baseY = allCommentsButton.frame.origin.y + allCommentsButton.frame.size.height;
    }
    else if(withLastComment && [self.commentUserButtons count]) {
        baseY = [self yValueOfLastComment];
    }
    else if(!likesChevron.hidden) {
        baseY = likesBackground.frame.origin.y + likesBackground.frame.size.height;
    }
    else if(endorsementLabel.text && endorsementLabel.text.length) {
        baseY = endorsementLabel.frame.origin.y + endorsementLabel.frame.size.height;
    }
    else {
        baseY = [self yValueOfBoughtArea];
    }
    
    return baseY;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Sub view creation

//----------------------------------------------------------------------------------------------------
- (void)createInfoBackground {
    infoBackground = [CALayer layer];
    infoBackground.frame = CGRectMake(11,
                                      purchaseImageButton.frame.origin.y + purchaseImageButton.frame.size.height+16,
                                      298,
                                      kPurchaseFeedCellHeight-purchaseImageButton.frame.size.height-16-purchaseImageButton.frame.origin.y);
    infoBackground.cornerRadius = 6;
    infoBackground.backgroundColor = [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1.0].CGColor;
    //infoBackground.borderWidth = 1.0f;
    //infoBackground.borderColor = [UIColor colorWithRed:0.878 green:0.878 blue:0.878 alpha:1.0].CGColor;
    
    [self.contentView.layer addSublayer:infoBackground];
}

//----------------------------------------------------------------------------------------------------
- (void)createDoinkImageView {
    UIImageView *doinkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(31,infoBackground.frame.origin.y-7,16,8)];
    doinkImageView.image = [UIImage imageNamed:kImgDoinkUp];
    
    [self.contentView addSubview:doinkImageView];
}

//----------------------------------------------------------------------------------------------------
- (void)createUserImageButton {
    userImageButton  = [[UIButton alloc] initWithFrame:CGRectMake(22,infoBackground.frame.origin.y+11,34,34)];
    userImageButton.imageView.layer.cornerRadius = 4;
    userImageButton.imageView.backgroundColor = [UIColor colorWithRed:0.878 green:0.878 blue:0.878 alpha:1.0];
    userImageButton.adjustsImageWhenDisabled = NO;
    
    [userImageButton addTarget:self
                       action:@selector(didTapUserImageButton:)
             forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:userImageButton];
}

//----------------------------------------------------------------------------------------------------
- (void)createPurchaseImageButton {
    
    purchaseImageButton  = [[UIButton alloc] initWithFrame:CGRectMake(11,16,298,224)]; 
    //purchaseImageButton.backgroundColor = [UIColor redColor];
    purchaseImageButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    purchaseImageButton.adjustsImageWhenHighlighted = NO;
    purchaseImageButton.adjustsImageWhenDisabled = NO;
    
    [purchaseImageButton addTarget:self
                            action:@selector(didTapPurchaseImageButton:)
                  forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:purchaseImageButton];
}

//----------------------------------------------------------------------------------------------------
- (void)createBoughtLabel {
    boughtLabel = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(userImageButton.frame.origin.x+userImageButton.frame.size.width+8,
                                                                      userImageButton.frame.origin.y,
                                                                      kBoughtTextWidth,
                                                                      0)];
    boughtLabel.linkColor = kActiveColor;
    boughtLabel.underlineLinks = NO;
    boughtLabel.delegate = self;
    boughtLabel.automaticallyAddLinksForType = 0;
    boughtLabel.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:boughtLabel];
}

//----------------------------------------------------------------------------------------------------
- (void)createEndorsementLabel {
    
    endorsementLabel					= [[UILabel alloc] initWithFrame:CGRectMake(22,
                                                                                0,
                                                                                kEndorsementWidth,
                                                                                1)];
    endorsementLabel.font				= kEndorsementFont;	
    endorsementLabel.textColor          = [UIColor colorWithRed:0.333 green:0.333 blue:0.333 alpha:1.0];
    endorsementLabel.backgroundColor    = [UIColor clearColor];
    endorsementLabel.textAlignment      = UITextAlignmentLeft;
    endorsementLabel.numberOfLines      = 0;
    endorsementLabel.lineBreakMode      = UILineBreakModeWordWrap;
    
    [self.contentView addSubview:endorsementLabel];
}

//----------------------------------------------------------------------------------------------------
- (void)createLikeButton {
    
    likeButton = [[UIButton alloc] initWithFrame:CGRectMake(22,0,76,25)];
    
    
    [likeButton setImage:[UIImage imageNamed:kImgLikeOff] 
                forState:UIControlStateNormal];
    
    [likeButton setImage:[UIImage imageNamed:kImgLikeOn] 
                forState:UIControlStateHighlighted];
    
    [likeButton setImage:[UIImage imageNamed:kImgLikePushed] 
                forState:UIControlStateDisabled];
    
    
    [likeButton addTarget:self
                       action:@selector(didTapLikeButton:)
             forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:likeButton];
}

//----------------------------------------------------------------------------------------------------
- (void)createCommentButton {
    
    commentButton = [[UIButton alloc] initWithFrame:CGRectMake(104,0,76,25)];
    
    [commentButton setImage:[UIImage imageNamed:kImgCommentOff]
                   forState:UIControlStateNormal];
    
    [commentButton setImage:[UIImage imageNamed:kImgCommentOn]
                   forState:UIControlStateHighlighted];
    
    [commentButton addTarget:self
                   action:@selector(didTapCommentButton:)
         forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:commentButton];
}


//----------------------------------------------------------------------------------------------------
- (void)createURLButton {
    
    urlButton = [[UIButton alloc] initWithFrame:CGRectMake(222,0,76,25)];
    
    [urlButton setImage:[UIImage imageNamed:kImgURLOff]
                   forState:UIControlStateNormal];
    
    [urlButton setImage:[UIImage imageNamed:kImgURLOn]
                   forState:UIControlStateHighlighted];
    
    [urlButton addTarget:self
                      action:@selector(didTapURLButton:)
            forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:urlButton];
}

//----------------------------------------------------------------------------------------------------
- (void)createAllCommentsButton {
    allCommentsButton = [[UIButton alloc] initWithFrame:CGRectMake(53,0,0,34)];
    allCommentsButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13];
    allCommentsButton.backgroundColor = [UIColor clearColor];
    
    [allCommentsButton setTitleColor:kActiveColor forState:UIControlStateNormal];
    
    [allCommentsButton addTarget:self
                          action:@selector(didTapAllCommentsButton:)
                forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:allCommentsButton];
}

//----------------------------------------------------------------------------------------------------
- (void)createLikesBackground {
    likesBackground = [CALayer layer];
    likesBackground.backgroundColor = [UIColor whiteColor].CGColor;
    likesBackground.frame = CGRectMake(22,0,250,44);
    likesBackground.cornerRadius = 6;
    
    [self.contentView.layer addSublayer:likesBackground];
}

//----------------------------------------------------------------------------------------------------
- (void)createLikesCountLabel {
    likesCountLabel					= [[OHAttributedLabel alloc] initWithFrame:CGRectMake(33,0,0,41)];
    likesCountLabel.backgroundColor	= [UIColor clearColor];
    boughtLabel.automaticallyAddLinksForType = 0;
    
    [self.contentView addSubview:likesCountLabel]; 
}

//----------------------------------------------------------------------------------------------------
- (void)createLikeUserImages {
    
    for(NSInteger i=0 ; i<kTotalLikeUserImages ; i++) {
        UIImageView *likeUserImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,24,24)];
        
        likeUserImage.backgroundColor = [UIColor colorWithRed:0.878 green:0.878 blue:0.878 alpha:1.0];
        likeUserImage.layer.cornerRadius = 2;
        likeUserImage.layer.masksToBounds = YES;
        
        [self.likeUserImages addObject:likeUserImage];
        
        [self.contentView addSubview:likeUserImage];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)createLikesChevron {
    likesChevron = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 9, 13)];
    likesChevron.image = [UIImage imageNamed:kImgChevron];
    
    [self.contentView addSubview:likesChevron];
}

//----------------------------------------------------------------------------------------------------
- (void)createAllLikesButton {
    allLikesButton = [[UIButton alloc] initWithFrame:CGRectZero];
    
    allLikesButton.backgroundColor = [UIColor clearColor];
    
    [allLikesButton addTarget:self
                       action:@selector(didTapAllLikesButton:)
             forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:allLikesButton];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Accessor methods to populate cell UI

//----------------------------------------------------------------------------------------------------
- (void)resetLikesUI {
    
    likeButton.enabled = YES;
    
    for(UIButton *likeUserImage in self.likeUserImages) 
        likeUserImage.hidden = YES;
    
    likesBackground.hidden = YES;
    likesCountLabel.hidden = YES;
    likesChevron.hidden = YES;
    allLikesButton.hidden = YES;
    allCommentsButton.hidden = YES;
    
    commentsBaseY = 0;
    
    if(!self.isInteractive) {
        [purchaseImageButton setEnabled:NO];
        [userImageButton setEnabled:NO];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)resetCommentsUI {
    
    for(UIButton *commentUserButton in self.commentUserButtons)
        [commentUserButton removeFromSuperview];
    
    for(UILabel *commentMessageLabel in self.commentMessageLabels)
        [commentMessageLabel removeFromSuperview];
    
    self.commentUserButtons     = [NSMutableArray array];
    self.commentMessageLabels   = [NSMutableArray array];
}

//----------------------------------------------------------------------------------------------------
- (void)setUserImage:(UIImage *)image {
    [userImageButton setImage:image forState:UIControlStateNormal];
}

//----------------------------------------------------------------------------------------------------
- (void)setPurchaseImage:(UIImage*)image {
    [purchaseImageButton setImage:image forState:UIControlStateNormal];
}

//----------------------------------------------------------------------------------------------------
- (void)setBoughtText:(NSString*)boughtText 
         withUserName:(NSString*)userName 
        withTimestamp:(NSString*)timestamp {
    
    NSRange userNameRange = NSMakeRange(0,userName.length);
    NSRange timestampRange = NSMakeRange(boughtText.length+1,timestamp.length);
    
	NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:[NSString stringWithFormat:@"%@ %@",boughtText,timestamp]];
	[attrStr setFont:kBoughtTextFont];
	[attrStr setTextColor:[UIColor colorWithRed:0.333 green:0.333 blue:0.333 alpha:1.0]];
    [attrStr setTextAlignment:UITextAlignmentLeft lineBreakMode:UILineBreakModeWordWrap lineHeight:2];
    
    [attrStr setFont:[UIFont fontWithName:@"HelveticaNeue" size:10] range:timestampRange];
    [attrStr setTextColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0] range:timestampRange];
    
	[attrStr setTextBold:YES range:userNameRange];

    
    CGRect frame = boughtLabel.frame;
    frame.size.width = kBoughtTextWidth;
    frame.size.height = 0;
    boughtLabel.frame = frame;
    
    
    boughtLabel.attributedText = attrStr;
    [boughtLabel sizeToFit];
    
    
    if(self.isInteractive) {
        [boughtLabel addCustomLink:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%d",kUserURLScheme,self.userID]]
                           inRange:userNameRange];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)setEndorsement:(NSString*)endorsement {
    
    CGRect frame = endorsementLabel.frame;
    frame.origin.y =  [self yValueOfBoughtArea] + 7;
    frame.size.width = kEndorsementWidth;
    endorsementLabel.frame = frame;
    
    endorsementLabel.text = endorsement;
    [endorsementLabel sizeToFit];
}

//----------------------------------------------------------------------------------------------------
- (void)setInteractionButtonsWithLikedStatus:(BOOL)liked {
    
    if(self.isInteractive) {
        CGRect frame = likeButton.frame;
        frame.origin.y = [self yValueOfCellWithLastComment:YES
                                     withAllCommentsButton:YES] + 10;
        likeButton.frame = frame;
        
        likeButton.enabled = !liked;
        
        
        frame = commentButton.frame;
        frame.origin.y = likeButton.frame.origin.y;
        commentButton.frame = frame;
        
        
        frame = urlButton.frame;
        frame.origin.y = likeButton.frame.origin.y;
        urlButton.frame = frame;
        
        
        CGRect infoFrame = infoBackground.frame;
        infoFrame.size.height = likeButton.frame.origin.y + likeButton.frame.size.height - infoFrame.origin.y + 12;
        infoBackground.frame = infoFrame;        
    }
    else {
        likeButton.hidden = YES;
        commentButton.hidden = YES;
        urlButton.hidden = YES;
        
        CGRect infoFrame = infoBackground.frame;
        infoFrame.size.height = [self yValueOfCellWithLastComment:NO
                                            withAllCommentsButton:NO] - infoFrame.origin.y + 11;
        infoBackground.frame = infoFrame;
    }
}

//----------------------------------------------------------------------------------------------------
- (void)setLikeCount:(NSInteger)count {

    if(!count)
        return;
    
    NSString *countText = nil;
    NSString *baseText = nil;
    likesBackground.hidden = NO;
    likesCountLabel.hidden = NO;
    likesChevron.hidden = NO;
    allLikesButton.hidden = NO;
    
    if(count == 1) {
        countText = @"1";
        baseText = @"1 like";
    }
    else {
        countText = [NSString stringWithFormat:@"%d",count];
        baseText = [NSString stringWithFormat:@"%@ likes",countText];
    }
    
    CGRect frame = likesBackground.frame;
    frame.origin.y =  endorsementLabel.frame.origin.y + endorsementLabel.frame.size.height + (endorsementLabel.text.length ?  9 : 3);
    likesBackground.frame = frame;
    
    frame = likesCountLabel.frame;
    frame.origin.x = likesBackground.frame.origin.x + 11;
    frame.origin.y = likesBackground.frame.origin.y + 4;
    frame.size.width = 200;
    likesCountLabel.frame = frame;
    
    
    
    NSRange countRange = NSMakeRange(0,countText.length);
    
	NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:baseText];
    
	[attrStr setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
	[attrStr setTextColor:[UIColor colorWithRed:0.333 green:0.333 blue:0.333 alpha:1.0]];
    
    [attrStr setFont:[UIFont fontWithName:@"HelveticaNeue" size:31] range:countRange];
	[attrStr setTextBold:YES range:countRange];
    
    likesCountLabel.attributedText = attrStr;
    [likesCountLabel sizeToFit];
    
    
    CGFloat chevronX = 0;
    
    for(NSInteger i=0; i<MIN(count,kTotalLikeUserImages) ; i++) {
        UIButton *likeUserButton = [self.likeUserImages objectAtIndex:i];

        CGRect frame = likeUserButton.frame;
        frame.origin.x = likesCountLabel.frame.origin.x + likesCountLabel.frame.size.width + 6 + (i * 28);
        frame.origin.y = likesBackground.frame.origin.y + 10;
        likeUserButton.frame = frame;
        likeUserButton.hidden = NO;
        
        chevronX = frame.origin.x;
    }
    
    frame = likesChevron.frame;
    frame.origin.x = chevronX + 10 + 24;
    frame.origin.y = likesBackground.frame.origin.y + 15;
    likesChevron.frame = frame;
    
    frame = likesBackground.frame;
    frame.size.width =  likesChevron.frame.origin.x + likesChevron.frame.size.width - likesBackground.frame.origin.x + 10;
    likesBackground.frame = frame;
    allLikesButton.frame = frame;
}

//----------------------------------------------------------------------------------------------------
- (void)setLikeImage:(UIImage*)image 
    forButtonAtIndex:(NSInteger)index
           forUserID:(NSInteger)userID {
    
    if(index >= [self.likeUserImages count])
        return;
    
    UIImageView *likeUserImage = [self.likeUserImages objectAtIndex:index];
    
    likeUserImage.image = image;
}

//----------------------------------------------------------------------------------------------------
- (void)createCommentWithUserImage:(UIImage*)image
                      withUserName:(NSString*)userName
                        withUserID:(NSInteger)userID
                        andMessage:(NSString*)message {
    
    if(!commentsBaseY) {
        commentsBaseY = [self yValueOfCellWithLastComment:NO
                                    withAllCommentsButton:NO] + 4;
    }
    
    
    NSInteger previousCommentY = [self yValueOfLastComment];
        
    if(!previousCommentY)
        previousCommentY = commentsBaseY;
    
    
    UIButton *commentUserButton = [[UIButton alloc] initWithFrame:CGRectMake(22,
                                                                            previousCommentY + 10,
                                                                             24,
                                                                             24)];
    commentUserButton.imageView.backgroundColor = [UIColor colorWithRed:0.878 green:0.878 blue:0.878 alpha:1.0];
    commentUserButton.imageView.layer.cornerRadius = 2;
    commentUserButton.tag = userID;
    
    [commentUserButton setImage:image
                       forState:UIControlStateNormal];
    
    [commentUserButton addTarget:self
                       action:@selector(didTapCommentUserImageButton:)
             forControlEvents:UIControlEventTouchUpInside];
     
    [self.commentUserButtons addObject:commentUserButton];
    
    [self.contentView addSubview:commentUserButton];
    
    
    
    NSString *commentText = [NSString stringWithFormat:@"%@: %@",userName,message];
    
    OHAttributedLabel *commentMessageLabel = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(53, 
                                                                             commentUserButton.frame.origin.y-3,
                                                                             kCommentWidth,
                                                                             0)];
    commentMessageLabel.backgroundColor = [UIColor clearColor];
    commentMessageLabel.automaticallyAddLinksForType = 0;
    commentMessageLabel.linkColor = kActiveColor;
    commentMessageLabel.underlineLinks = NO;
    commentMessageLabel.delegate = self;
    
    NSRange nameRange = NSMakeRange(0,userName.length);
    
	NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:commentText];
    
	[attrStr setFont:kCommentFont];
	[attrStr setTextColor:[UIColor colorWithRed:0.333 green:0.333 blue:0.333 alpha:1.0]];
    [attrStr setTextAlignment:UITextAlignmentLeft lineBreakMode:UILineBreakModeWordWrap lineHeight:2];
    
	[attrStr setTextBold:YES range:NSMakeRange(0,userName.length+1)];
    
    commentMessageLabel.attributedText = attrStr;
    [commentMessageLabel sizeToFit];
    
    [commentMessageLabel addCustomLink:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%d",kUserURLScheme,userID]]
                               inRange:nameRange];
    
    
    [self.commentMessageLabels addObject:commentMessageLabel];
    
    [self.contentView addSubview:commentMessageLabel];
}

//----------------------------------------------------------------------------------------------------
- (void)setCommentUserImage:(UIImage*)image
           forButtonAtIndex:(NSInteger)index {
    
    if(index >= [self.commentUserButtons count])
        return;
    
    UIButton *commentUserButton = [self.commentUserButtons objectAtIndex:index];
    
    [commentUserButton setImage:image
                       forState:UIControlStateNormal];
}

//----------------------------------------------------------------------------------------------------
- (void)setAllCommentsButtonWithCount:(NSInteger)count {
    [allCommentsButton setTitle:[NSString stringWithFormat:@"View all %d comments",count]
                       forState:UIControlStateNormal];
    
    CGRect frame = allCommentsButton.frame;
    frame.size.width = 250;
    frame.origin.y = [self yValueOfLastComment] + 9;
    allCommentsButton.frame = frame;
    [allCommentsButton sizeToFit];
    
    allCommentsButton.hidden = NO;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Static methods

//----------------------------------------------------------------------------------------------------
+ (NSInteger)heightForCellWithLikesCount:(NSInteger)likesCount 
                                comments:(NSMutableArray *)comments
                           isInteractive:(BOOL)isInteractive
                             endorsement:(NSString *)endorsement
                              boughtText:(NSString*)boughtText { 
    
    NSInteger height = kPurchaseFeedCellHeight;
    
    height += MAX([boughtText sizeWithFont:kBoughtTextFont
                     constrainedToSize:CGSizeMake(kBoughtTextWidth,1500)
                         lineBreakMode:UILineBreakModeWordWrap].height,kUserImageSide);
    
    if(endorsement && endorsement.length)
        height += [endorsement sizeWithFont:kEndorsementFont
                          constrainedToSize:CGSizeMake(kEndorsementWidth,1500)
                              lineBreakMode:UILineBreakModeWordWrap].height;

    if(isInteractive) {
        height += 24 + 10 + 11;
        
        height += likesCount > 0 ? 44 + (endorsement.length ? 9 : 3) : 0;
        
        if(comments.count)
            height += 5;
        
        for(NSInteger i=0 ; i<MIN(comments.count,kTotalComments) ; i++) {
            DWComment *comment = [comments objectAtIndex:i];
            NSInteger textHeight = [[NSString stringWithFormat:@"%@: %@",comment.user.fullName,comment.message] sizeWithFont:kCommentFont 
                                                                                                           constrainedToSize:CGSizeMake(kCommentWidth,1500)
                                                                                                               lineBreakMode:UILineBreakModeWordWrap].height;
            height += MAX(24,textHeight) + 10;
        }
        
        if([comments count] > kTotalComments)
            height += 34 + 9;
    }
    
    return  height;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark OHAttributedLabelDelegate

//----------------------------------------------------------------------------------------------------
-(BOOL)attributedLabel:(OHAttributedLabel *)attributedLabel 
      shouldFollowLink:(NSTextCheckingResult *)linkInfo {

    [self userClicked:[[linkInfo.URL resourceSpecifier] integerValue]];
    
    return true;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UI Events

//----------------------------------------------------------------------------------------------------
- (void)didTapPurchaseImageButton:(UIButton*)button {
    [self fireExternalURLDelegate];
}

//----------------------------------------------------------------------------------------------------
- (void)didTapURLButton:(UIButton*)button {
    [self fireExternalURLDelegate];
}

//----------------------------------------------------------------------------------------------------
- (void)didTapUserImageButton:(UIButton*)button {
    [self userClicked:self.userID];
}

//----------------------------------------------------------------------------------------------------
- (void)didTapUserNameButton:(UIButton*)button {
    [self userClicked:self.userID];
}

//----------------------------------------------------------------------------------------------------
- (void)didTapCommentUserImageButton:(UIButton*)button {
    [self userClicked:button.tag];
}

//----------------------------------------------------------------------------------------------------
- (void)didTapCommentUserNameButton:(UIButton*)button {
    [self userClicked:button.tag];
}

//----------------------------------------------------------------------------------------------------
- (void)didTapLikeButton:(UIButton*)button {

    SEL sel = @selector(likeClickedForPurchaseID:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    [self.delegate performSelector:sel
                        withObject:[NSNumber numberWithInteger:self.purchaseID]];
}

//----------------------------------------------------------------------------------------------------
- (void)didTapAllLikesButton:(UIButton*)button {
    
    SEL sel = @selector(allLikesClickedForPurchaseID:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    [self.delegate performSelector:sel
                        withObject:[NSNumber numberWithInteger:self.purchaseID]];
}

//----------------------------------------------------------------------------------------------------
- (void)didTapCommentButton:(UIButton*)button {
    
    SEL sel = @selector(commentClickedForPurchaseID:withCreationIntent:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    [self.delegate performSelector:sel
                        withObject:[NSNumber numberWithInteger:self.purchaseID]
                        withObject:[NSNumber numberWithBool:YES]];
}
//----------------------------------------------------------------------------------------------------
- (void)didTapAllCommentsButton:(UIButton*)button {
    
    SEL sel = @selector(commentClickedForPurchaseID:withCreationIntent:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    [self.delegate performSelector:sel
                        withObject:[NSNumber numberWithInteger:self.purchaseID]
                        withObject:[NSNumber numberWithBool:NO]];
}

@end
