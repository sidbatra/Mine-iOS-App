//
//  DWPurchaseFeedCell.m
//  Mine
//
//  Created by Siddharth Batra on 7/22/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWPurchaseFeedCell.h"

NSInteger const kPurchaseFeedCellHeight = 400;


@interface DWPurchaseFeedCell() {
    
}

/**
 * Fires the delegate event after a user element is clicked.
 */
- (void)userClicked;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWPurchaseFeedCell

@synthesize purchaseID  = _purchaseID;
@synthesize delegate    = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)initWithStyle:(UITableViewCellStyle)style 
	reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style
				reuseIdentifier:reuseIdentifier];
	
    if (self) {
        [self createUserImageView];
        [self createPurchaseImageView];
        [self createUserNameButton];
		[self createTitleLabel];
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;	
	}
	
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)userClicked {  
    
    SEL sel = @selector(userClickedForPurchaseID:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    [self.delegate performSelector:sel
                        withObject:[NSNumber numberWithInteger:self.purchaseID]];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Sub view creation

//----------------------------------------------------------------------------------------------------
- (void)createUserImageView {
    userImageView                   = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,50,50)];
    purchaseImageView.contentMode   = UIViewContentModeScaleAspectFit;
    userImageView.backgroundColor   = [UIColor yellowColor];
    
    [self.contentView addSubview:userImageView];
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
    
    userNameButton                 = [[UIButton alloc] initWithFrame:CGRectMake(55,
                                                                                5,
                                                                                250,
                                                                                30)];
    userNameButton.titleLabel.font              = [UIFont fontWithName:@"HelveticaNeue" size:13];
    userNameButton.titleLabel.textColor         = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    userNameButton.titleLabel.backgroundColor	= [UIColor redColor];
    userNameButton.titleLabel.textAlignment     = UITextAlignmentLeft;
    
    [userNameButton addTarget:self
                    action:@selector(didTapUserNameButton:)
          forControlEvents:UIControlEventTouchDown];
    
    
    [self.contentView addSubview:userNameButton];
}

//----------------------------------------------------------------------------------------------------
- (void)createTitleLabel {
    
    titleLabel					= [[UILabel alloc] initWithFrame:CGRectMake(20,
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
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Accessor methods to populate cell UI

//----------------------------------------------------------------------------------------------------
- (void)setUserImage:(UIImage *)image {
    userImageView.image = image;
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
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UI Events

//----------------------------------------------------------------------------------------------------
- (void)didTapUserNameButton:(UIButton*)button {
    [self userClicked];
}

@end
