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
#import "DWConstants.h"



static NSInteger const kPurchaseProfileCellHeight = 180;
static NSInteger const kPurchaseImageSide = 144;
static NSInteger const kSpinnerSide = 20;
static NSInteger const kBackgroundBottomMargin = 12;
static NSInteger const kMaxTitleLength = 45;

static NSString* const kImgMiniChevron = @"doink-up-8.png";
static NSString* const kImgSpinnerBackground = @"delete-loading.png";

#define kTitleFont [UIFont fontWithName:@"HelveticaNeue" size:10]


@interface DWPurchaseProfileCell() {
    NSMutableArray  *_imageButtons;
    NSMutableArray  *_titleButtons;
    NSMutableArray  *_backgroundLayers;
    NSMutableArray  *_chevrons;
    NSMutableArray  *_spinners;
    NSMutableArray  *_spinnerBackgrounds;
}


@property (nonatomic,strong) NSMutableArray *imageButtons;
@property (nonatomic,strong) NSMutableArray *titleButtons;
@property (nonatomic,strong) NSMutableArray *backgroundLayers;
@property (nonatomic,strong) NSMutableArray *chevrons;
@property (nonatomic,strong) NSMutableArray *spinners;
@property (nonatomic,strong) NSMutableArray *spinnerBackgrounds;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWPurchaseProfileCell

@synthesize imageButtons        = _imageButtons;
@synthesize titleButtons        = _titleButtons;
@synthesize backgroundLayers    = _backgroundLayers;
@synthesize chevrons            = _chevrons;
@synthesize spinners            = _spinners;
@synthesize spinnerBackgrounds  = _spinnerBackgrounds;
@synthesize delegate            = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)initWithStyle:(UITableViewCellStyle)style 
	reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style
				reuseIdentifier:reuseIdentifier];
	
    if (self) {
        self.contentView.clipsToBounds = YES;
        self.imageButtons       = [NSMutableArray arrayWithCapacity:kColumnsInPurchaseSearch];
        self.titleButtons       = [NSMutableArray arrayWithCapacity:kColumnsInPurchaseSearch];
        self.backgroundLayers   = [NSMutableArray arrayWithCapacity:kColumnsInPurchaseSearch];
        self.chevrons           = [NSMutableArray arrayWithCapacity:kColumnsInPurchaseSearch];
        
        [self createImageButtons];
        [self createTitleButtons];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;	
	}
	
    return self;
}

//----------------------------------------------------------------------------------------------------
+ (NSInteger)heightForCellWithPurchases:(NSMutableArray*)purchases {
    
    NSInteger height = 0;
    
    for(DWPurchase *purchase in purchases) {
        
        NSString *title = purchase.title;
        
        //if([title length] > kMaxTitleLength)
        //    title = [NSString stringWithFormat:@"%@...",[title substringToIndex:kMaxTitleLength-3]];
        
        NSInteger newHeight = [title sizeWithFont:kTitleFont
                                constrainedToSize:CGSizeMake(126,1000)
                                    lineBreakMode:UILineBreakModeWordWrap].height;
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
        imageButton.backgroundColor = [UIColor whiteColor];
        
         [imageButton addTarget:self
         action:@selector(didTapImageButton:)
         forControlEvents:UIControlEventTouchUpInside];
        
        [self.imageButtons addObject:imageButton];
        
        [self.contentView addSubview:imageButton];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)createTitleButtons {
    
    for(NSInteger i=0; i<kColumnsInPurchaseSearch; i++) {
        
        CALayer *backgroundLayer = [CALayer layer];
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
        frame.origin.x += 9;
        frame.origin.y += 7;
        frame.size.width -= 18;
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
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Accessor methods to populate cell UI

//----------------------------------------------------------------------------------------------------
- (void)resetUI {
    
    for(UIButton *imageButton in self.imageButtons) 
        imageButton.hidden = YES;
    
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
}

//----------------------------------------------------------------------------------------------------
- (void)setPurchaseTitle:(NSString*)title
                forIndex:(NSInteger)index 
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
    
    //if([title length] > kMaxTitleLength)
    //    title = [NSString stringWithFormat:@"%@...",[title substringToIndex:kMaxTitleLength-3]];
    
    [titleButton setTitle:title 
                 forState:UIControlStateNormal];
    
    CGRect frame = backgroundLayer.frame;
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
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UI Events

//----------------------------------------------------------------------------------------------------
- (void)didTapImageButton:(UIButton*)button {
    [self.delegate purchaseClicked:button.tag];
}

//----------------------------------------------------------------------------------------------------
- (void)didTapTitleButton:(UIButton*)button {
    [self.delegate purchaseClicked:button.tag];
    //[self.delegate purchaseURLClicked:button.tag];
}

@end
