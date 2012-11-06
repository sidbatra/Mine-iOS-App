//
//  DWPurchaseProfileCell.m
//  Mine
//
//  Created by Siddharth Batra on 8/3/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWPurchaseProfileCell.h"

#import <QuartzCore/QuartzCore.h>

#import "DWPurchase.h"
#import "DWStore.h"
#import "DWUser.h"
#import "DWConstants.h"



static NSInteger const kPurchaseProfileCellHeight = 180;
static NSInteger const kPurchaseImageSide = 144;
static NSInteger const kUserImageSide = 25;
static NSInteger const kSpinnerSide = 20;
static NSInteger const kBackgroundBottomMargin = 12;
static NSInteger const kMaxTitleLength = NSIntegerMax;
static NSInteger const kMaxTitleLengthInUserMode = 29;

static NSString* const kImgMiniChevron = @"doink-up-8.png";
static NSString* const kImgSpinnerBackground = @"delete-loading.png";
static NSString* const kImgCrossButtonOn = @"feed-btn-x-on.png";
static NSString* const kImgCrossButtonOff = @"feed-btn-x-off.png";

#define kTitleFont [UIFont fontWithName:@"HelveticaNeue" size:10]
#define kColorImageBackground [UIColor colorWithRed:0.862 green:0.862 blue:0.862 alpha:1.0]


@interface DWPurchaseProfileCell() {
    NSMutableArray  *_imageButtons;
    NSMutableArray  *_userImageButtons;
    NSMutableArray  *_titleButtons;
    NSMutableArray  *_backgroundLayers;
    NSMutableArray  *_chevrons;
    NSMutableArray  *_spinners;
    NSMutableArray  *_spinnerBackgrounds;
    NSMutableArray  *_crossButtons;
}


@property (nonatomic,strong) NSMutableArray *imageButtons;
@property (nonatomic,strong) NSMutableArray *titleButtons;
@property (nonatomic,strong) NSMutableArray *userImageButtons;
@property (nonatomic,strong) NSMutableArray *backgroundLayers;
@property (nonatomic,strong) NSMutableArray *chevrons;
@property (nonatomic,strong) NSMutableArray *spinners;
@property (nonatomic,strong) NSMutableArray *spinnerBackgrounds;
@property (nonatomic,strong) NSMutableArray *crossButtons;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWPurchaseProfileCell

@synthesize userMode            = _userMode;
@synthesize imageButtons        = _imageButtons;
@synthesize userImageButtons    = _userImageButtons;
@synthesize titleButtons        = _titleButtons;
@synthesize backgroundLayers    = _backgroundLayers;
@synthesize chevrons            = _chevrons;
@synthesize spinners            = _spinners;
@synthesize spinnerBackgrounds  = _spinnerBackgrounds;
@synthesize crossButtons        = _crossButtons;
@synthesize delegate            = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)initWithStyle:(UITableViewCellStyle)style 
	reuseIdentifier:(NSString *)reuseIdentifier
           userMode:(BOOL)userMode {
    
    self = [super initWithStyle:style
				reuseIdentifier:reuseIdentifier];
	
    if (self) {
        self.userMode = userMode;
        
        self.contentView.clipsToBounds = YES;
        self.imageButtons       = [NSMutableArray arrayWithCapacity:kColumnsInPurchaseSearch];
        self.titleButtons       = [NSMutableArray arrayWithCapacity:kColumnsInPurchaseSearch];
        self.backgroundLayers   = [NSMutableArray arrayWithCapacity:kColumnsInPurchaseSearch];
        self.chevrons           = [NSMutableArray arrayWithCapacity:kColumnsInPurchaseSearch];
        
        [self createImageButtons];
        [self createTitleButtons];
        
        if(self.userMode) {
            self.userImageButtons = [NSMutableArray arrayWithCapacity:kColumnsInPurchaseSearch];
            [self createUserImageButtons];
        }
        
        
        self.contentView.backgroundColor = [UIColor whiteColor];
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;	
	}
	
    return self;
}

//----------------------------------------------------------------------------------------------------
+ (NSString*)fullTitleForPurchaseWithTitle:(NSString*)title
                                     store:(NSString*)store
                            andUserPronoun:(NSString*)pronoun
                                inUserMode:(BOOL)userMode {
    
    NSMutableString* fullTitle = nil;

   // NSInteger maxLength = 0;
    
    if(userMode) {
        fullTitle = [NSMutableString stringWithFormat:@"bought %@ %@",pronoun,title];
        //maxLength = kMaxTitleLengthInUserMode;
    }
    else {
        fullTitle = [NSMutableString stringWithString:title];
        //maxLength = kMaxTitleLength;
    }
    
    if(store)
        [fullTitle appendFormat:@" from %@",store];
    
    //if([fullTitle length] > maxLength)
    //    fullTitle = [NSString stringWithFormat:@"%@...",[fullTitle substringToIndex:maxLength-3]];
    
    return fullTitle;
}

//----------------------------------------------------------------------------------------------------
+ (NSInteger)heightForCellWithPurchases:(NSMutableArray*)purchases
                             inUserMode:(BOOL)userMode {
    
    NSInteger height = 0;
    
    for(DWPurchase *purchase in purchases) {
        
        NSString *title = [self fullTitleForPurchaseWithTitle:purchase.title
                                                        store:purchase.store ? purchase.store.name : nil
                                               andUserPronoun:purchase.user.pronoun
                                                   inUserMode:userMode];
        
        NSInteger newHeight = [title sizeWithFont:kTitleFont
                                constrainedToSize:CGSizeMake(userMode ? 95 : 126,1000)
                                    lineBreakMode:UILineBreakModeWordWrap].height;
        
        if(userMode)
            newHeight = MAX(kUserImageSide,newHeight);
        
        if(newHeight > height)
            height = newHeight;
    }
    
    return kPurchaseProfileCellHeight + height;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Sub view creation

//----------------------------------------------------------------------------------------------------
- (void)createImageButtons {
    
    for(NSInteger i=0 ; i<kColumnsInPurchaseSearch ; i++) {
        UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake((kPurchaseImageSide+10)*i + 11,11,kPurchaseImageSide,kPurchaseImageSide)];
        
        imageButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageButton.backgroundColor = kColorImageBackground;
        
        [imageButton addTarget:self
                        action:@selector(didTapImageButton:)
              forControlEvents:UIControlEventTouchUpInside];

        
        [self.imageButtons addObject:imageButton];
        
        [self.contentView addSubview:imageButton];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)createUserImageButtons {
 
    for(NSInteger i=0 ; i<kColumnsInPurchaseSearch ; i++) {
        UIButton *userImageButton = [[UIButton alloc] initWithFrame:CGRectMake((kPurchaseImageSide+10)*i + 11 + 9,11+kPurchaseImageSide+9+7,kUserImageSide,kUserImageSide)];
        
        userImageButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        userImageButton.imageView.layer.cornerRadius = 2;
        //userImageButton.enabled = NO;
        //userImageButton.adjustsImageWhenDisabled = NO;
        
        //[userImageButton addTarget:self
        //                    action:@selector(didTapUserImageButton:)
        //          forControlEvents:UIControlEventTouchUpInside];
        
        [self.userImageButtons addObject:userImageButton];
        
        [self.contentView addSubview:userImageButton];
    }

}

//----------------------------------------------------------------------------------------------------
- (void)createTitleButtons {
    
    for(NSInteger i=0; i<kColumnsInPurchaseSearch; i++) {
        
        CALayer *backgroundLayer = [CALayer layer];
        backgroundLayer.actions = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNull null], @"onOrderIn",
                                  [NSNull null], @"position",
                                  [NSNull null], @"hidden",
                                  [NSNull null], @"onOrderOut",
                                  [NSNull null], @"sublayers",
                                  [NSNull null], @"contents",
                                  [NSNull null], @"bounds",
                                  nil];
        backgroundLayer.cornerRadius = 4;
        backgroundLayer.backgroundColor = [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1.0].CGColor;
        backgroundLayer.frame = CGRectMake((kPurchaseImageSide+10)*i + 11,11+kPurchaseImageSide+9,kPurchaseImageSide,42);
        
        [self.backgroundLayers addObject:backgroundLayer];
        
        [self.contentView.layer addSublayer:backgroundLayer];
        
        
        UIImageView *chevronView = [[UIImageView alloc] initWithFrame:CGRectMake(backgroundLayer.frame.origin.x+10,backgroundLayer.frame.origin.y-4,8,4)];
        chevronView.image = [UIImage imageNamed:kImgMiniChevron];
        [self.contentView addSubview:chevronView];
        
        [self.chevrons addObject:chevronView];
        
        
        UIButton *titleButton = [[UIButton alloc] init];
        
        CGRect frame = backgroundLayer.frame;
        frame.origin.x += 9 + (self.userMode ? kUserImageSide + 6 : 0);
        frame.origin.y += 7;
        frame.size.width -= 18 + (self.userMode ? kUserImageSide + 6 : 0);
        frame.size.height -= kBackgroundBottomMargin;
        
        titleButton.frame = frame;
        titleButton.backgroundColor             = [UIColor clearColor];
        titleButton.contentVerticalAlignment    = UIControlContentVerticalAlignmentTop;
        titleButton.contentHorizontalAlignment  = UIControlContentHorizontalAlignmentLeft;
        titleButton.titleLabel.font             = kTitleFont;
        titleButton.titleLabel.backgroundColor  = [UIColor clearColor];
        titleButton.titleLabel.textAlignment    = UITextAlignmentLeft;
        titleButton.titleLabel.numberOfLines    = 2;
        titleButton.titleLabel.lineBreakMode    = UILineBreakModeWordWrap;
        
        [titleButton setTitleColor:[UIColor colorWithRed:0.333 green:0.333 blue:0.333 alpha:1.0]  
                          forState:UIControlStateNormal];
        
        [titleButton addTarget:self
                        action:@selector(didTapTitleButton:)
              forControlEvents:UIControlEventTouchUpInside];
        
        
        [self.titleButtons addObject:titleButton];
        
        [self.contentView addSubview:titleButton];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)createSpinners {
    
    self.spinners = [NSMutableArray arrayWithCapacity:kColumnsInPurchaseSearch];
    self.spinnerBackgrounds = [NSMutableArray arrayWithCapacity:kColumnsInPurchaseSearch];

    for(NSInteger i=0; i<kColumnsInPurchaseSearch; i++) {
        UIButton *imageButton = [self.imageButtons objectAtIndex:i];
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(imageButton.frame.origin.x + (imageButton.frame.size.width - kSpinnerSide) / 2,
                                                                                                     imageButton.frame.origin.y + (imageButton.frame.size.height - kSpinnerSide) / 2,
                                                                                                     kSpinnerSide,
                                                                                                     kSpinnerSide)];
        
        spinner.hidden = YES;
        spinner.hidesWhenStopped = YES;
        spinner.color = [UIColor whiteColor];
        
        [self.spinners addObject:spinner];
        
        
        UIImageView *spinnerBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kImgSpinnerBackground]];
        spinnerBackground.frame = CGRectMake(imageButton.frame.origin.x + (imageButton.frame.size.width - 44) / 2,
                                     imageButton.frame.origin.y + (imageButton.frame.size.height - 44) / 2,
                                     44,
                                     44);
        spinnerBackground.hidden = YES;
        
        [self.spinnerBackgrounds addObject:spinnerBackground];
        
        [self.contentView addSubview:spinnerBackground];
        [self.contentView addSubview:spinner];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)createCrossButtons {
        
    self.crossButtons = [NSMutableArray arrayWithCapacity:kColumnsInPurchaseSearch];
    
    for(NSInteger i=0 ; i<kColumnsInPurchaseSearch; i++) {
        UIButton *imageButton = [self.imageButtons objectAtIndex:i];
        
        UIButton *crossButton = [[UIButton alloc] initWithFrame:CGRectMake(imageButton.frame.origin.x+114, imageButton.frame.origin.y+5, 25, 25)];
        
        crossButton.hidden = YES;

        [crossButton setImage:[UIImage imageNamed:kImgCrossButtonOff]
                     forState:UIControlStateNormal];
        
        [crossButton setImage:[UIImage imageNamed:kImgCrossButtonOn]
                     forState:UIControlStateHighlighted];
        
        [crossButton addTarget:self
                        action:@selector(didTapCrossButton:)
              forControlEvents:UIControlEventTouchUpInside];
        
        [self.crossButtons addObject:crossButton];
        
        [self.contentView addSubview:crossButton];
    }
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Accessor methods to populate cell UI

//----------------------------------------------------------------------------------------------------
- (void)resetUI {
    
    for(UIButton *imageButton in self.imageButtons) 
        imageButton.hidden = YES;
    
    for(UIButton *userImageButton in self.userImageButtons)
        userImageButton.hidden = YES;
    
    for(UIButton *titleButton in self.titleButtons)
        titleButton.hidden = YES;
    
    for(CALayer *backgroundLayer in self.backgroundLayers)
        backgroundLayer.hidden = YES;
    
    for(UIImageView *chevron in self.chevrons)
        chevron.hidden = YES;
    
    for(UIActivityIndicatorView *spinner in self.spinners) {
        spinner.hidden = YES;
        [spinner stopAnimating];
    }
    
    for(UIImageView *spinnerBackground in self.spinnerBackgrounds)
        spinnerBackground.hidden = YES;
    
    for(UIButton *crossButton in self.crossButtons)
        crossButton.hidden = YES;
}

//----------------------------------------------------------------------------------------------------
- (void)setPurchaseImage:(UIImage*)image 
                forIndex:(NSInteger)index 
          withPurchaseID:(NSInteger)purchaseID {
    
    if(index >= [self.imageButtons count])
        return;
    
    UIButton *imageButton = [self.imageButtons objectAtIndex:index];    
    imageButton.tag = purchaseID;
    imageButton.hidden = NO;
    
    [imageButton setImage:image
                 forState:UIControlStateNormal];
    
    [imageButton setImage:image
                 forState:UIControlStateHighlighted];
    
    if(image)
        imageButton.backgroundColor = [UIColor whiteColor];
    else
        imageButton.backgroundColor = kColorImageBackground;
}

//----------------------------------------------------------------------------------------------------
- (void)setUserImage:(UIImage*)image
            forIndex:(NSInteger)index
          withUserID:(NSInteger)userID {
    
    if(index >= [self.userImageButtons count])
        return;
    
    UIButton *userImageButton = [self.userImageButtons objectAtIndex:index];
    userImageButton.tag = userID;
    userImageButton.hidden = NO;
    
    [userImageButton setImage:image
                 forState:UIControlStateNormal];
    
    [userImageButton setImage:image
                 forState:UIControlStateHighlighted];
    
    if(image)
        userImageButton.backgroundColor = [UIColor whiteColor];
    else
        userImageButton.backgroundColor = kColorImageBackground;
    
}

//----------------------------------------------------------------------------------------------------
- (void)setPurchaseTitle:(NSString*)title
                   store:(NSString*)store
                forIndex:(NSInteger)index
         withUserPronoun:(NSString*)pronoun
          withPurchaseID:(NSInteger)purchaseID {
    
    if(index >= [self.titleButtons count])
        return;
    
    CALayer *backgroundLayer = [self.backgroundLayers objectAtIndex:index];
    backgroundLayer.hidden = NO;
    
    UIImageView *chevron = [self.chevrons objectAtIndex:index];
    chevron.hidden = NO;
    
    
    UIButton *titleButton = [self.titleButtons objectAtIndex:index];
    titleButton.tag = purchaseID;
    titleButton.hidden = NO;
    
    
    NSString *fullTitle = [[self class] fullTitleForPurchaseWithTitle:title
                                                                store:store
                                                       andUserPronoun:pronoun
                                                           inUserMode:self.userMode];
    
    [titleButton setTitle:fullTitle
                 forState:UIControlStateNormal];
    
    CGRect frame = backgroundLayer.frame;
    
    if(self.userMode)
        frame.size.height = MAX(kUserImageSide,titleButton.titleLabel.frame.size.height) + kBackgroundBottomMargin;
    else
        frame.size.height = titleButton.titleLabel.frame.size.height + kBackgroundBottomMargin;
    
    backgroundLayer.frame = frame;
    
    frame = titleButton.frame;
    frame.size.height =titleButton.titleLabel.frame.size.height;
    titleButton.frame = frame;
}

//----------------------------------------------------------------------------------------------------
- (void)enterSpinningStateForIndex:(NSInteger)index {
    if(!self.spinners)
        [self createSpinners];
    
    UIActivityIndicatorView *spinner = [self.spinners objectAtIndex:index];
    [spinner startAnimating];
    spinner.hidden = NO;
    
    
    UIImageView *spinnerBackground = [self.spinnerBackgrounds objectAtIndex:index];
    spinnerBackground.hidden = NO;
}

//----------------------------------------------------------------------------------------------------
- (void)displayCrossButtonForIndex:(NSInteger)index
                    withPurchaseID:(NSInteger)purchaseID {
    
    if(!self.crossButtons)
        [self createCrossButtons];
    
    UIButton *crossButton = [self.crossButtons objectAtIndex:index];
    crossButton.tag = purchaseID;
    crossButton.hidden = NO;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UI Events

//----------------------------------------------------------------------------------------------------
- (void)didTapImageButton:(UIButton*)button {
    SEL sel = @selector(purchaseClicked:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    [self.delegate purchaseClicked:button.tag];
}

//----------------------------------------------------------------------------------------------------
- (void)didTapTitleButton:(UIButton*)button {
    SEL sel = @selector(purchaseClicked:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    [self.delegate purchaseClicked:button.tag];
    //[self.delegate purchaseURLClicked:button.tag];
}

//----------------------------------------------------------------------------------------------------
- (void)didTapCrossButton:(UIButton*)button {
    SEL sel = @selector(purchaseCrossClicked:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    
    [self.delegate purchaseCrossClicked:button.tag];
}

@end
