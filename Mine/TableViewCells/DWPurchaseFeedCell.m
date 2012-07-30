//
//  DWPurchaseFeedCell.m
//  Mine
//
//  Created by Siddharth Batra on 7/22/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWPurchaseFeedCell.h"
#import "DWUser.h"
#import "DWLike.h"

NSInteger const kPurchaseFeedCellHeight = 400;
NSInteger const kTotalLikeUserButtons   = 5;


@interface DWPurchaseFeedCell() {
    NSMutableArray  *_likeUserButtons;
    
    NSMutableArray  *_commentUserButtons;
    NSMutableArray  *_commentUserNameButtons;
    NSMutableArray  *_commentMessageLabels;
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
@synthesize delegate                = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)initWithStyle:(UITableViewCellStyle)style 
	reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style
				reuseIdentifier:reuseIdentifier];
	
    if (self) {
        self.contentView.clipsToBounds = YES;
        
        self.likeUserButtons    = [NSMutableArray arrayWithCapacity:kTotalLikeUserButtons];
        
        [self createUserImageButton];
        [self createPurchaseImageView];
        [self createUserNameButton];
		[self createTitleLabel];
        [self createLikesCountLabel];
        [self createLikeUserButtons];
		
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
- (void)createUserImageButton {
    userImageButton  = [[UIButton alloc] initWithFrame:CGRectMake(0,0,50,50)];
    
    
    [userImageButton addTarget:self
                       action:@selector(didTapUserImageButton:)
             forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:userImageButton];
}

//----------------------------------------------------------------------------------------------------
- (void)createPurchaseImageView {
    purchaseImageView                   = [[UIImageView alloc] initWithFrame:CGRectMake(0,50,320,320)];
    purchaseImageView.contentMode       = UIViewContentModeScaleAspectFit;
    purchaseImageView.backgroundColor   = [UIColor yellowColor];
    
    [self.contentView addSubview:purchaseImageView];
}

//----------------------------------------------------------------------------------------------------
- (void)createUserNameButton {
    
    userNameButton = [[UIButton alloc] initWithFrame:CGRectMake(55,5,250,30)];
    
    userNameButton.titleLabel.font              = [UIFont fontWithName:@"HelveticaNeue" size:13];
    userNameButton.titleLabel.textColor         = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    userNameButton.titleLabel.backgroundColor	= [UIColor redColor];
    userNameButton.titleLabel.textAlignment     = UITextAlignmentLeft;
    
    [userNameButton addTarget:self
                    action:@selector(didTapUserNameButton:)
          forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.contentView addSubview:userNameButton];
}

//----------------------------------------------------------------------------------------------------
- (void)createTitleLabel {
    
    titleLabel					= [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                                370,
                                                                                self.contentView.frame.size.width-40,
                                                                                30)];
    titleLabel.font				= [UIFont fontWithName:@"HelveticaNeue" size:13];	
    titleLabel.textColor		= [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    titleLabel.backgroundColor	= [UIColor redColor];
    titleLabel.textAlignment	= UITextAlignmentLeft;
    
    [self.contentView addSubview:titleLabel];
}

//----------------------------------------------------------------------------------------------------
- (void)createLikesCountLabel {
    likesCountLabel					= [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                            400,
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
        UIButton *likeUserButton = [[UIButton alloc] initWithFrame:CGRectMake(45 + i*35, 400, 30,30)];
        
        likeUserButton.backgroundColor = [UIColor redColor];
        
        [likeUserButton addTarget:self
                           action:@selector(didTapLikeUserImageButton:)
                 forControlEvents:UIControlEventTouchUpInside];
        
        [self.likeUserButtons addObject:likeUserButton];
        
        [self.contentView addSubview:likeUserButton];
    }
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Accessor methods to populate cell UI

//----------------------------------------------------------------------------------------------------
- (void)resetLikesUI {
    
    for(UIButton *likeUserButton in self.likeUserButtons) 
        likeUserButton.hidden = YES;
    
    likesCountLabel.hidden = YES;
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
    purchaseImageView.image = image;
}

//----------------------------------------------------------------------------------------------------
- (void)setUserName:(NSString *)userName {
    [userNameButton setTitle:userName forState:UIControlStateNormal];
}

//----------------------------------------------------------------------------------------------------
- (void)setTitle:(NSString*)title {
    titleLabel.text = title;
}

//----------------------------------------------------------------------------------------------------
- (void)setLikeCount:(NSInteger)count {

    if(!count)
        return;
    
    likesCountLabel.hidden = NO;
    
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
                                                                            450 + [self.commentUserButtons count] * 110,
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
                                                                             450 + [self.commentUserNameButtons count] * 110,
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
                                                                             450 + [self.commentMessageLabels count] * 110 + 35 ,
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
                        andCommentsCount:(NSInteger)commentsCount {
    
    NSInteger height = kPurchaseFeedCellHeight;
    
    height +=likesCount > 0 ? 40 : 0;
    height += commentsCount > 0 ? 125 * commentsCount : 0;
    
    return  height;
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

@end
