//
//  DWPurchaseFeedCell.m
//  Mine
//
//  Created by Siddharth Batra on 7/22/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "NSAttributedString+Attributes.h"

#import "DWPurchaseFeedCell.h"
#import "DWUser.h"
#import "DWLike.h"


NSInteger const kPurchaseFeedCellHeight = 370;
NSInteger const kTotalLikeUserButtons   = 5;

static NSString* const kImgDoinkUp  = @"doink-up-14.png";
static NSString* const kImgActionBg = @"btn-action-bg.png";


@interface DWPurchaseFeedCell() {
    NSMutableArray  *_likeUserButtons;
    
    NSMutableArray  *_commentUserButtons;
    NSMutableArray  *_commentUserNameButtons;
    NSMutableArray  *_commentMessageLabels;
    
    NSURL           *_userNameLabelURL;
}


/**
 * User image buttons for the likers of this purchase.
 */
@property (nonatomic,strong) NSMutableArray *likeUserButtons;

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
@synthesize likeUserButtons         = _likeUserButtons;
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
        
        self.likeUserButtons    = [NSMutableArray arrayWithCapacity:kTotalLikeUserButtons];
        self.userNameLabelURL   = [NSURL URLWithString:[NSString stringWithFormat:@"user"]];
        
        [self createPurchaseImageButton];
        
        [self createInfoBackground];
        [self createDoinkImageView];
        
        [self createUserImageButton];
        [self createBoughtLabel];
        [self createEndorsementLabel];
        
        [self createAllLikesButton];
        [self createLikeButton];
        
        //[self createCommentButton];
        
        //[self createLikesCountLabel];
        //[self createLikeUserButtons];
        
        
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
    infoBackground.frame = CGRectMake(-1,
                                      purchaseImageButton.frame.origin.y + purchaseImageButton.frame.size.height+11,
                                      self.contentView.frame.size.width+1,
                                      kPurchaseFeedCellHeight-purchaseImageButton.frame.size.height-11-purchaseImageButton.frame.origin.y);
    infoBackground.backgroundColor = [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1.0].CGColor;
    infoBackground.borderWidth = 1.0f;
    infoBackground.borderColor = [UIColor colorWithRed:0.878 green:0.878 blue:0.878 alpha:1.0].CGColor;
    
    [self.contentView.layer addSublayer:infoBackground];
}

//----------------------------------------------------------------------------------------------------
- (void)createDoinkImageView {
    UIImageView *doinkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40,infoBackground.frame.origin.y-7,16,8)];
    doinkImageView.image = [UIImage imageNamed:kImgDoinkUp];
    
    [self.contentView addSubview:doinkImageView];
}

//----------------------------------------------------------------------------------------------------
- (void)createUserImageButton {
    userImageButton  = [[UIButton alloc] initWithFrame:CGRectMake(11,infoBackground.frame.origin.y+11,34,34)];
    userImageButton.imageView.layer.cornerRadius = 3;
    userImageButton.backgroundColor = [UIColor colorWithRed:0.878 green:0.878 blue:0.878 alpha:1.0];
    
    [userImageButton addTarget:self
                       action:@selector(didTapUserImageButton:)
             forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:userImageButton];
}

//----------------------------------------------------------------------------------------------------
- (void)createPurchaseImageButton {
    
    purchaseImageButton  = [[UIButton alloc] initWithFrame:CGRectMake(11,11,298,224)];
    //purchaseImageButton.backgroundColor = [UIColor redColor];
    purchaseImageButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    purchaseImageButton.adjustsImageWhenHighlighted = NO;
    
    /*
    [purchaseImageButton addTarget:self
                            action:@selector(didTapUserImageButton:)
                  forControlEvents:UIControlEventTouchUpInside];
    */
    
    [self.contentView addSubview:purchaseImageButton];
}

//----------------------------------------------------------------------------------------------------
- (void)createBoughtLabel {
    boughtLabel = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(userImageButton.frame.origin.x+userImageButton.frame.size.width+16,
                                                                      userImageButton.frame.origin.y,
                                                                      229,
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
    
    endorsementLabel					= [[UILabel alloc] initWithFrame:CGRectMake(11,
                                                                                userImageButton.frame.origin.y+userImageButton.frame.size.height+11,
                                                                                298,
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
- (void)createLikesCountLabel {
    likesCountLabel					= [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                            430,
                                                                            40,
                                                                            30)];
    likesCountLabel.font            = [UIFont fontWithName:@"HelveticaNeue" size:13];	
    likesCountLabel.textColor		= [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    likesCountLabel.backgroundColor	= [UIColor blueColor];
    likesCountLabel.textAlignment	= UITextAlignmentLeft;
    
    [self.contentView addSubview:likesCountLabel]; 
}

//----------------------------------------------------------------------------------------------------
- (void)createLikeUserButtons {
    
    for(NSInteger i=0 ; i<kTotalLikeUserButtons ; i++) {
        UIButton *likeUserButton = [[UIButton alloc] initWithFrame:CGRectMake(45 + i*35, 430, 30,30)];
        
        likeUserButton.backgroundColor = [UIColor redColor];
        
        [likeUserButton addTarget:self
                           action:@selector(didTapLikeUserImageButton:)
                 forControlEvents:UIControlEventTouchUpInside];
        
        [self.likeUserButtons addObject:likeUserButton];
        
        [self.contentView addSubview:likeUserButton];
    }
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
    
    [likeButton setTitle:@"Like" forState:UIControlStateNormal];
    likeButton.enabled = YES;
    
    for(UIButton *likeUserButton in self.likeUserButtons) 
        likeUserButton.hidden = YES;
    
    likesCountLabel.hidden = YES;
    //allLikesButton.hidden = YES;
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
    frame.size.width = 298;
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
    
    CGRect infoFrame = infoBackground.frame;
    infoFrame.size.height =  allLikesButton.frame.origin.y + allLikesButton.frame.size.height - infoFrame.origin.y + 10;
    infoBackground.frame = infoFrame;
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
    
    likesCountLabel.hidden = NO;
    //allLikesButton.hidden = count <= 5;
    
    if(count == 1)
        likesCountLabel.text = @"1 like";
    else
        likesCountLabel.text = [NSString stringWithFormat:@"%d likes",count];
}

//----------------------------------------------------------------------------------------------------
- (void)setLikeImage:(UIImage*)image 
    forButtonAtIndex:(NSInteger)index
           forUserID:(NSInteger)userID {
    
    if(index >= [self.likeUserButtons count])
        return;
    
    UIButton *likeUserButton = [self.likeUserButtons objectAtIndex:index];
    
    likeUserButton.tag = userID;
    
    [likeUserButton setImage:image
                    forState:UIControlStateNormal];
    
    likeUserButton.hidden = NO;
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
                          constrainedToSize:CGSizeMake(298,750)
                              lineBreakMode:UILineBreakModeWordWrap].height;
    
    //height +=likesCount > 0 ? 40 : 0;
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
