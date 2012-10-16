//
//  DWNotificationCell.m
//  Mine
//
//  Created by Siddharth Batra on 10/14/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWNotificationCell.h"

#import <QuartzCore/QuartzCore.h>
#import "OHAttributedLabel.h"
#import "NSAttributedString+Attributes.h"

#import "DWConstants.h"

static NSInteger const kNotificationCellHeight  = 51;
static NSInteger const kTextWidth               = 230;
static NSInteger const kTextCharCount           = 64;
static NSInteger const kNotificationImageSide   = 50;

#define kBackgroundColor [UIColor clearColor];
#define kBorderColor [UIColor colorWithRed:0.862 green:0.862 blue:0.862 alpha:1.0]
#define kNotificationFont [UIFont fontWithName:@"HelveticaNeue" size:13]


@interface DWNotificationCell() {
    UIImageView *notificationImage;
    UILabel *bottomBorder;
    
    OHAttributedLabel   *textLabel;
    
    BOOL _highlighted;
}

@property (nonatomic,assign) BOOL highlighted;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWNotificationCell

@synthesize highlighted = _highlighted;

//----------------------------------------------------------------------------------------------------
- (id)initWithStyle:(UITableViewCellStyle)style
	reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style
				reuseIdentifier:reuseIdentifier];
	
    if (self) {
        self.contentView.clipsToBounds = YES;
        
        [self createNotificationImage];
        [self createTextLabel];
        [self createChevron];
        [self createBorders];
    
		self.selectionStyle = UITableViewCellSelectionStyleBlue;
	}
	
    return self;
}


//----------------------------------------------------------------------------------------------------
- (void)createBorders {
    //UILabel *topBorder = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width,1)];
    //topBorder.backgroundColor = [UIColor colorWithRed:0.972 green:0.972 blue:0.972 alpha:1.0];
    
    //[self.contentView addSubview:topBorder];
    
    
    bottomBorder = [[UILabel alloc] initWithFrame:CGRectMake(0, kNotificationCellHeight-1, self.contentView.frame.size.width,1)];
    bottomBorder.backgroundColor = kBorderColor;
    
    [self.contentView addSubview:bottomBorder];
}

//----------------------------------------------------------------------------------------------------
- (void)createChevron {
    UIImageView *chevron = [[UIImageView alloc] initWithFrame:CGRectMake(298,18,9,13)];
    chevron.image = [UIImage imageNamed:kImgChevron];
    chevron.highlightedImage = [UIImage imageNamed:kImgChevronWhite];
    
    [self.contentView addSubview:chevron];
}

//----------------------------------------------------------------------------------------------------
- (void)createNotificationImage {
    notificationImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,kNotificationImageSide,kNotificationImageSide)];
    
    [self.contentView addSubview:notificationImage];
}

//----------------------------------------------------------------------------------------------------
- (void)createTextLabel {
    
    textLabel =  [[OHAttributedLabel alloc] initWithFrame:CGRectMake(notificationImage.frame.origin.x + notificationImage.frame.size.width + 10,
                                                                        10,
                                                                        kTextWidth,
                                                                        34)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.highlightedTextColor = [UIColor whiteColor];
    textLabel.automaticallyAddLinksForType = 0;
    textLabel.underlineLinks = NO;
    textLabel.centerVertically = YES;
    
    [self.contentView addSubview:textLabel];
}

//----------------------------------------------------------------------------------------------------
- (void)resetUI {
    [self resetDarkMode];
}

//----------------------------------------------------------------------------------------------------
- (void)setNotificationImage:(UIImage*)image {
    notificationImage.image = image;
    notificationImage.highlightedImage = image;
}

//----------------------------------------------------------------------------------------------------
- (void)setEvent:(NSString*)event entity:(NSString*)entity {

    NSString *text = [NSString stringWithFormat:@"%@ %@",entity,event];
        
    if(text.length > kTextCharCount)
        text = [NSString stringWithFormat:@"%@...",[text substringToIndex:kTextCharCount-3]];
    
	NSMutableAttributedString* attrStr = [[self class] createAttributedText:text
                                                                     entity:entity];
    
    textLabel.attributedText = attrStr;
}

//----------------------------------------------------------------------------------------------------
- (void)resetDarkMode {
    self.contentView.backgroundColor = kBackgroundColor;
}

//----------------------------------------------------------------------------------------------------
- (void)setDarkMode {
    self.contentView.backgroundColor = [UIColor whiteColor];
}

//----------------------------------------------------------------------------------------------------
- (void)setHighlighted:(BOOL)highlighted
			  animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
	
    if(highlighted && !self.highlighted) {
        self.highlighted = YES;
        bottomBorder.backgroundColor = kBorderColor;
    }
    else if(!highlighted && self.highlighted) {
        self.highlighted = NO;
        [self resetDarkMode];
    }
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Static methods

//----------------------------------------------------------------------------------------------------
+ (NSMutableAttributedString*)createAttributedText:(NSString*)text entity:(NSString*)entity {
    
    NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:text];
    
	[attrStr setFont:kNotificationFont];
	[attrStr setTextColor:[UIColor colorWithRed:0.537 green:0.537 blue:0.537 alpha:1.0]];
    [attrStr setTextAlignment:UITextAlignmentLeft lineBreakMode:UILineBreakModeWordWrap lineHeight:2];
    
	[attrStr setTextBold:YES range:NSMakeRange(0,entity.length)];
    [attrStr setTextColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0] range:NSMakeRange(0,entity.length)];
    
    return attrStr;
}

//----------------------------------------------------------------------------------------------------
+ (NSInteger)heightForCellWithEvent:(NSString*)event entity:(NSString*)entity {
    return kNotificationCellHeight;
}


@end
