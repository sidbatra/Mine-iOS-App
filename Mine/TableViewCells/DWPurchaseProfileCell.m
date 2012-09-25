//
//  DWPurchaseProfileCell.m
//  Mine
//
//  Created by Siddharth Batra on 8/3/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWPurchaseProfileCell.h"

#import <QuartzCore/QuartzCore.h>

#import "DWConstants.h"



static NSInteger const kPurchaseProfileCellHeight = 210;
static NSInteger const kPurchaseImageSide = 144;
static NSString* const kImgMiniChevron = @"doink-up-8.png";


@interface DWPurchaseProfileCell() {
    NSMutableArray  *_imageButtons;
    NSMutableArray  *_titleButtons;
}


/**
 * Image buttons for the purchases.
 */
@property (nonatomic,strong) NSMutableArray *imageButtons;

/**
 * Title buttons for the purchases.
 */
@property (nonatomic,strong) NSMutableArray *titleButtons;

@end




//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWPurchaseProfileCell

@synthesize imageButtons    = _imageButtons;
@synthesize titleButtons    = _titleButtons;
@synthesize delegate        = _delegate;


//----------------------------------------------------------------------------------------------------
- (id)initWithStyle:(UITableViewCellStyle)style 
	reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style
				reuseIdentifier:reuseIdentifier];
	
    if (self) {
        self.contentView.clipsToBounds = YES;
        self.imageButtons   = [NSMutableArray arrayWithCapacity:kColumnsInPurchaseSearch];
        self.titleButtons   = [NSMutableArray arrayWithCapacity:kColumnsInPurchaseSearch];
        
        [self createImageButtons];
        [self createTitleButtons];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;	
	}
	
    return self;
}

//----------------------------------------------------------------------------------------------------
+ (NSInteger)heightForCell {
    return kPurchaseProfileCellHeight;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Sub view creation

//----------------------------------------------------------------------------------------------------
- (void)createImageButtons {
    
    for(NSInteger i=0 ; i<kColumnsInPurchaseSearch ; i++) {
        UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake((kPurchaseImageSide+8)*i + 11,11,kPurchaseImageSide,kPurchaseImageSide)];
        
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
        backgroundLayer.frame = CGRectMake((kPurchaseImageSide+8)*i + 11,11+kPurchaseImageSide+8,kPurchaseImageSide,42);
        
        [self.contentView.layer addSublayer:backgroundLayer];
        
        
        UIImageView *chevronView = [[UIImageView alloc] initWithFrame:CGRectMake(backgroundLayer.frame.origin.x+10,backgroundLayer.frame.origin.y-4,8,4)];
        chevronView.image = [UIImage imageNamed:kImgMiniChevron];
        [self.contentView addSubview:chevronView];
        
        
        UIButton *titleButton = [[UIButton alloc] init];

        CGRect frame = backgroundLayer.frame;
        frame.origin.x += 9;
        frame.origin.y += 6;
        frame.size.width -= 18;
        frame.size.height -= 12;
        
        titleButton.frame = frame;
        titleButton.backgroundColor             = [UIColor clearColor];
        titleButton.contentVerticalAlignment    = UIControlContentVerticalAlignmentTop;
        titleButton.contentHorizontalAlignment  = UIControlContentHorizontalAlignmentLeft;
        titleButton.titleLabel.font             = [UIFont fontWithName:@"HelveticaNeue" size:10];
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
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Accessor methods to populate cell UI

//----------------------------------------------------------------------------------------------------
- (void)resetUI {
    
    for(UIButton *imageButton in self.imageButtons) 
        imageButton.hidden = YES;
    
    for(UIButton *titleButton in self.titleButtons)
        titleButton.hidden = YES;
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
    
    UIButton *titleButton = [self.titleButtons objectAtIndex:index];
    titleButton.tag = purchaseID;
    titleButton.hidden = NO;
    
    if([title length] > 50)
        title = [NSString stringWithFormat:@"%@...",[title substringToIndex:47]];
    
    [titleButton setTitle:title 
                 forState:UIControlStateNormal];
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
