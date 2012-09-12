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
#import "DWConstants.h"


NSInteger const kTotalLikeUserImages = 6;

static NSString* const kImgDoinkUp  = @"doink-up-16.png";
static NSString* const kImgActionBg = @"btn-action-bg.png";
static NSInteger const kEndorsementWidth = 274;
static NSInteger const kPurchaseFeedCellHeight = 350;

@interface DWPurchaseFeedCell() {
    NSMutableArray  *_likeUserImages;
    
    NSMutableArray  *_commentUserButtons;
    NSMutableArray  *_commentUserNameButtons;
    NSMutableArray  *_commentMessageLabels;
    
    NSURL           *_userNameLabelURL;
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
 * User name buttons for the comments.
 */
@property (nonatomic,strong) NSMutableArray *commentUserNameButtons;

/**
 * Comment message labels.
 */
@property (nonatomic,strong) NSMutableArray *commentMessageLabels;

/**
 * URL used to idenfity clicks on the user name.
 */
@property (nonatomic,strong) NSURL *userNameLabelURL;

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
@synthesize commentUserNameButtons  = _commentUserNameButtons;
@synthesize commentMessageLabels    = _commentMessageLabels;
@synthesize userNameLabelURL        = _userNameLabelURL;
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
        self.userNameLabelURL   = [NSURL URLWithString:[NSString stringWithFormat:@"user"]];
        
        [self createPurchaseImageButton];
        
        [self createInfoBackground];
        [self createDoinkImageView];
        
        [self createUserImageButton];
        [self createBoughtLabel];
        [self createEndorsementLabel];
        
        //[self createAllLikesButton];
        //[self createLikeButton];
        
        //[self createCommentButton];
        
        [self createLikesBackground];
        [self createLikesCountLabel];
        [self createLikeUserImages];
        [self createLikesChevron];
        
        
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
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Sub view creation

//----------------------------------------------------------------------------------------------------
- (void)createInfoBackground {
    infoBackground = [CALayer layer];
    infoBackground.frame = CGRectMake(11,
                                      purchaseImageButton.frame.origin.y + purchaseImageButton.frame.size.height+11,
                                      298,
                                      kPurchaseFeedCellHeight-purchaseImageButton.frame.size.height-11-purchaseImageButton.frame.origin.y);
    infoBackground.cornerRadius = 6;
    infoBackground.backgroundColor = [UIColor colorWithRed:0.960 green:0.960 blue:0.960 alpha:1.0].CGColor;
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
    userImageButton.imageView.layer.cornerRadius = 3;
    userImageButton.backgroundColor = [UIColor colorWithRed:0.878 green:0.878 blue:0.878 alpha:1.0];
    
    [userImageButton addTarget:self
                       action:@selector(didTapUserImageButton:)
             forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:userImageButton];
}

//----------------------------------------------------------------------------------------------------
- (void)createPurchaseImageButton {
    
    purchaseImageButton  = [[UIButton alloc] initWithFrame:CGRectMake(11,11,kEndorsementWidth,224)];
    //purchaseImageButton.backgroundColor = [UIColor redColor];
    purchaseImageButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    purchaseImageButton.adjustsImageWhenHighlighted = NO;
    
    
    [purchaseImageButton addTarget:self
                            action:@selector(didTapPurchaseImageButton:)
                  forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:purchaseImageButton];
}

//----------------------------------------------------------------------------------------------------
- (void)createBoughtLabel {
    boughtLabel = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(userImageButton.frame.origin.x+userImageButton.frame.size.width+16,
                                                                      userImageButton.frame.origin.y,
                                                                      228,
                                                                      34)];
    boughtLabel.linkColor = [UIColor colorWithRed:0.333 green:0.333 blue:0.333 alpha:1.0];
    boughtLabel.underlineLinks = NO;
    boughtLabel.delegate = self;
    boughtLabel.automaticallyAddLinksForType = 0;
    boughtLabel.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:boughtLabel];
}

//----------------------------------------------------------------------------------------------------
- (void)createEndorsementLabel {
    
    endorsementLabel					= [[UILabel alloc] initWithFrame:CGRectMake(22,
                                                                                userImageButton.frame.origin.y+userImageButton.frame.size.height+11,
                                                                                kEndorsementWidth,
                                                                                1)];
    endorsementLabel.font				= [UIFont fontWithName:@"HelveticaNeue" size:13];	
    endorsementLabel.textColor          = [UIColor colorWithRed:0.333 green:0.333 blue:0.333 alpha:1.0];
    endorsementLabel.backgroundColor    = [UIColor clearColor];
    endorsementLabel.textAlignment      = UITextAlignmentLeft;
    endorsementLabel.numberOfLines      = 0;
    endorsementLabel.lineBreakMode      = UILineBreakModeWordWrap;
    
    [self.contentView addSubview:endorsementLabel];
}

//----------------------------------------------------------------------------------------------------
- (void)createLikeButton {
    
    likeButton = [[UIButton alloc] initWithFrame:CGRectMake(11,400,76,24)];
    
    
    [likeButton setImage:[UIImage imageNamed:kImgActionBg] 
                forState:UIControlStateNormal];
    
    
    [likeButton addTarget:self
                       action:@selector(didTapLikeButton:)
             forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:likeButton];
}

//----------------------------------------------------------------------------------------------------
- (void)createCommentButton {
    
    commentButton = [[UIButton alloc] initWithFrame:CGRectMake(60,400,75,30)];
    
    commentButton.titleLabel.font               = [UIFont fontWithName:@"HelveticaNeue" size:13];
    commentButton.titleLabel.textColor          = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    commentButton.titleLabel.backgroundColor    = [UIColor blueColor];
    commentButton.titleLabel.textAlignment      = UITextAlignmentLeft;
    
    [commentButton setTitle:@"Comment"
                forState:UIControlStateNormal];
    
    [commentButton addTarget:self
                   action:@selector(didTapCommentButton:)
         forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:commentButton];
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
        likeUserImage.layer.cornerRadius = 3;
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
    allLikesButton = [[UIButton alloc] initWithFrame:CGRectMake(11,400,96,44)];

    allLikesButton.backgroundColor              = [UIColor whiteColor];
    allLikesButton.layer.borderColor            = [UIColor colorWithRed:0.843 green:0.843 blue:0.843 alpha:1.0].CGColor;
    allLikesButton.layer.borderWidth            = 1;
    allLikesButton.layer.cornerRadius           = 5;
    
    [allLikesButton addTarget:self
                       action:@selector(didTapAllLikeButton:)
             forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:allLikesButton];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Accessor methods to populate cell UI

//----------------------------------------------------------------------------------------------------
- (void)resetLikesUI {
    
    //[likeButton setTitle:@"Like" forState:UIControlStateNormal];
    likeButton.enabled = YES;
    
    for(UIButton *likeUserImage in self.likeUserImages) 
        likeUserImage.hidden = YES;
    
    likesBackground.hidden = YES;
    likesCountLabel.hidden = YES;
    likesChevron.hidden = YES;
    allLikesButton.hidden = YES;
}

//----------------------------------------------------------------------------------------------------
- (void)resetCommentsUI {
    
    for(UIButton *commentUserButton in self.commentUserButtons)
        [commentUserButton removeFromSuperview];
    
    for(UIButton *commentUserNameButton in self.commentUserNameButtons)
        [commentUserNameButton removeFromSuperview];
    
    for(UILabel *commentMessageLabel in self.commentMessageLabels)
        [commentMessageLabel removeFromSuperview];
    
    self.commentUserButtons     = [NSMutableArray array];
    self.commentUserNameButtons = [NSMutableArray array];
    self.commentMessageLabels   = [NSMutableArray array];
}

//----------------------------------------------------------------------------------------------------
- (void)setUserImage:(UIImage *)image {
    [userImageButton setImage:image forState:UIControlStateNormal];
}

//----------------------------------------------------------------------------------------------------
- (void)setPurchaseImage:(UIImage*)image {
    [purchaseImageButton setImage:image forState:UIControlStateNormal];
    //[purchaseImageButton setImage:image forState:UIControlStateHighlighted];
}

//----------------------------------------------------------------------------------------------------
- (void)setBoughtText:(NSString*)boughtText withUserName:(NSString*)userName  {
    
    NSRange userNameRange = NSMakeRange(0,userName.length);
    
	NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:boughtText];
	[attrStr setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
	[attrStr setTextColor:[UIColor colorWithRed:0.333 green:0.333 blue:0.333 alpha:1.0]];
    //[attrStr setTextAlignment:kCTLeftTextAlignment lineBreakMode:kCTLineBreakByWordWrapping];
    
	[attrStr setTextBold:YES range:userNameRange];
    
    boughtLabel.attributedText = attrStr;
    
    [boughtLabel addCustomLink:self.userNameLabelURL
                       inRange:userNameRange];
}

//----------------------------------------------------------------------------------------------------
- (void)setEndorsement:(NSString*)endorsement {
    
    CGRect frame = endorsementLabel.frame;
    frame.size.width = kEndorsementWidth;
    endorsementLabel.frame = frame;
    
    endorsementLabel.text = endorsement;
    [endorsementLabel sizeToFit];
    
    CGRect allLikeButtonFrame = allLikesButton.frame;
    allLikeButtonFrame.origin.y = endorsementLabel.frame.origin.y + endorsementLabel.frame.size.height;
    allLikesButton.frame = allLikeButtonFrame;
    
    CGRect likeButtonFrame = likeButton.frame;
    likeButtonFrame.origin.x = allLikesButton.frame.origin.x + 9;
    likeButtonFrame.origin.y = allLikesButton.frame.origin.y + 9;
    likeButton.frame = likeButtonFrame;
}

//----------------------------------------------------------------------------------------------------
- (void)disableLikeButton {
    //[likeButton setTitle:@"LIKED" forState:UIControlStateNormal];
    likeButton.enabled = NO;
}

//----------------------------------------------------------------------------------------------------
- (void)setLikeCount:(NSInteger)count {

    if(!count)
        return;
    
    NSString *countText = nil;
    NSString *baseText = nil;
    likesBackground.hidden = NO;
    likesCountLabel.hidden = NO;
    
    if(count == 1) {
        countText = @"1";
        baseText = @"1 like";
    }
    else {
        countText = [NSString stringWithFormat:@"%d",count];
        baseText = [NSString stringWithFormat:@"%@ likes",countText];
    }
    
    CGRect frame = likesBackground.frame;
    frame.origin.y = endorsementLabel.frame.origin.y + endorsementLabel.frame.size.height + 18;
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
        frame.origin.x = likesCountLabel.frame.origin.x + likesCountLabel.frame.size.width + 5 + (i * 27);
        frame.origin.y = likesBackground.frame.origin.y + 10;
        likeUserButton.frame = frame;
        likeUserButton.hidden = NO;
        
        chevronX = frame.origin.x;
    }
    
    frame = likesChevron.frame;
    frame.origin.x = chevronX + 10 + 24;
    frame.origin.y = likesBackground.frame.origin.y + 15;
    likesChevron.frame = frame;
    likesChevron.hidden = NO;
    
    frame = likesBackground.frame;
    frame.size.width =  likesChevron.frame.origin.x + likesChevron.frame.size.width - likesBackground.frame.origin.x + 10;
    likesBackground.frame = frame;
    
    
    CGRect infoFrame = infoBackground.frame;
    infoFrame.size.height = likesBackground.frame.origin.y + likesBackground.frame.size.height - infoFrame.origin.y + 10;
    infoBackground.frame = infoFrame;
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
    UIButton *commentUserButton = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                            480 + [self.commentUserButtons count] * 110,
                                                                             30,
                                                                             30)];
    commentUserButton.backgroundColor = [UIColor redColor];
    commentUserButton.tag = userID;
    
    [commentUserButton setImage:image
                       forState:UIControlStateNormal];
    
    [commentUserButton addTarget:self
                       action:@selector(didTapCommentUserImageButton:)
             forControlEvents:UIControlEventTouchUpInside];
     
    [self.commentUserButtons addObject:commentUserButton];
    
    [self.contentView addSubview:commentUserButton];
    
    
    UIButton *commentUserNameButton = [[UIButton alloc] initWithFrame:CGRectMake(50,
                                                                             480 + [self.commentUserNameButtons count] * 110,
                                                                             150,
                                                                             30)];
    commentUserNameButton.backgroundColor   = [UIColor redColor];
    commentUserNameButton.tag               = userID;
    
    commentUserNameButton.titleLabel.font               = [UIFont fontWithName:@"HelveticaNeue" size:13];
    commentUserNameButton.titleLabel.textColor          = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    commentUserNameButton.titleLabel.textAlignment      = UITextAlignmentLeft;
   
    [commentUserNameButton setTitle:userName
                           forState:UIControlStateNormal];
    
    [commentUserNameButton addTarget:self
                          action:@selector(didTapCommentUserNameButton:)
                forControlEvents:UIControlEventTouchUpInside];
    
    [self.commentUserNameButtons addObject:commentUserNameButton];
    
    [self.contentView addSubview:commentUserNameButton];
    
    
    
    UILabel *commentMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 
                                                                             480 + [self.commentMessageLabels count] * 110 + 35 ,
                                                                             self.contentView.frame.size.width - 10,
                                                                             60)];
    commentMessageLabel.numberOfLines       = 0;
    commentMessageLabel.text                = message;
    commentMessageLabel.backgroundColor     = [UIColor greenColor];
    commentMessageLabel.font                = [UIFont fontWithName:@"HelveticaNeue" size:13];
    commentMessageLabel.textColor           = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    commentMessageLabel.textAlignment       = UITextAlignmentLeft;
    [commentMessageLabel sizeToFit];
    
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
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Static methods

//----------------------------------------------------------------------------------------------------
+ (NSInteger)heightForCellWithLikesCount:(NSInteger)likesCount 
                           commentsCount:(NSInteger)commentsCount
                          andEndorsement:(NSString*)endorsement {
    
    NSInteger height = kPurchaseFeedCellHeight;
    
    if(endorsement && endorsement.length)
        height += [endorsement sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:13] 
                          constrainedToSize:CGSizeMake(kEndorsementWidth,750)
                              lineBreakMode:UILineBreakModeWordWrap].height;
    
    height +=likesCount > 0 ? 64 : 0;
    //height += commentsCount > 0 ? 125 * commentsCount : 0;
    
    return  height;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark OHAttributedLabelDelegate

//----------------------------------------------------------------------------------------------------
-(BOOL)attributedLabel:(OHAttributedLabel *)attributedLabel 
      shouldFollowLink:(NSTextCheckingResult *)linkInfo {
    
    [self userClicked:self.userID];
    
    return true;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UI Events

//----------------------------------------------------------------------------------------------------
- (void)didTapPurchaseImageButton:(UIButton*)button {
    
    SEL sel = @selector(purchaseURLClicked:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    [self.delegate performSelector:sel
                        withObject:[NSNumber numberWithInteger:self.purchaseID]];
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
- (void)didTapLikeUserImageButton:(UIButton*)button {
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
- (void)didTapAllLikeButton:(UIButton*)button {
    
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

@end
