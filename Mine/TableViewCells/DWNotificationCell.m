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

static NSInteger const kNotificationCellHeight = 20;
static NSInteger const kTextWidth = 250;
static NSInteger const kNotificationImageSide = 32;

#define kBackgroundColor [UIColor clearColor];
#define kNotificationFont [UIFont fontWithName:@"HelveticaNeue" size:14]


@interface DWNotificationCell() {
    UIImageView *notificationImage;
    
    OHAttributedLabel   *textLabel;
}

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWNotificationCell

//----------------------------------------------------------------------------------------------------
- (id)initWithStyle:(UITableViewCellStyle)style
	reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style
				reuseIdentifier:reuseIdentifier];
	
    if (self) {
        self.contentView.clipsToBounds = YES;
        
        [self createNotificationImage];
        [self createTextLabel];
    
		self.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)createNotificationImage {
    notificationImage = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,kNotificationImageSide,kNotificationImageSide)];
    notificationImage.layer.cornerRadius = 2;
    
    [self.contentView addSubview:notificationImage];
}

//----------------------------------------------------------------------------------------------------
- (void)createTextLabel {
    
    textLabel =  [[OHAttributedLabel alloc] initWithFrame:CGRectMake(notificationImage.frame.origin.y + notificationImage.frame.size.width + 9,
                                                                        10,
                                                                        kTextWidth,
                                                                        0)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.highlightedTextColor = [UIColor whiteColor];
    textLabel.automaticallyAddLinksForType = 0;
    textLabel.linkColor = [UIColor colorWithRed:0.090 green:0.435 blue:0.627 alpha:1.0];
    textLabel.underlineLinks = NO;
    
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

    NSString *text = [NSString stringWithFormat:@"%@: %@",entity,event];
    
	NSMutableAttributedString* attrStr = [[self class] createAttributedText:text
                                                                     entity:entity];
    
    CGRect frame = textLabel.frame;
    frame.size.height = 0;
    frame.size.width = kTextWidth;
    textLabel.frame = frame;
    
    textLabel.attributedText = attrStr;
    [textLabel sizeToFit];
}

//----------------------------------------------------------------------------------------------------
- (void)resetDarkMode {
    self.contentView.backgroundColor = kBackgroundColor;
}

//----------------------------------------------------------------------------------------------------
- (void)setDarkMode {
    self.contentView.backgroundColor = [UIColor redColor];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Static methods

//----------------------------------------------------------------------------------------------------
+ (NSMutableAttributedString*)createAttributedText:(NSString*)text entity:(NSString*)entity {
    
    NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:text];
    
	[attrStr setFont:kNotificationFont];
	[attrStr setTextColor:[UIColor colorWithRed:0.333 green:0.333 blue:0.333 alpha:1.0]];
    [attrStr setTextAlignment:UITextAlignmentLeft lineBreakMode:UILineBreakModeWordWrap lineHeight:2];
    
	[attrStr setTextBold:YES range:NSMakeRange(0,entity.length+1)];
    
    return attrStr;
}

//----------------------------------------------------------------------------------------------------
+ (NSInteger)heightForCellWithEvent:(NSString*)event entity:(NSString*)entity {
    
    NSMutableAttributedString* attrStr = [self createAttributedText:[NSString stringWithFormat:@"%@: %@",entity,event]
                                                             entity:entity];
    
    NSInteger textHeight = [attrStr sizeConstrainedToSize:CGSizeMake(kTextWidth,1500)].height;
    
    return kNotificationCellHeight +  MAX(kNotificationImageSide,textHeight);
}


@end
