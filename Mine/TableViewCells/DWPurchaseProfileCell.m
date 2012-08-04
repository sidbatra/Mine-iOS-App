//
//  DWPurchaseProfileCell.m
//  Mine
//
//  Created by Siddharth Batra on 8/3/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWPurchaseProfileCell.h"
#import "DWConstants.h"

/**
 * Base height of the purchase cell
 */
static NSInteger const kPurchaseProfileCellHeight = 150;


@interface DWPurchaseProfileCell() {
    NSMutableArray  *_imageButtons;
}


/**
 * Image buttons for the purchases.
 */
@property (nonatomic,strong) NSMutableArray *imageButtons;


@end




//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWPurchaseProfileCell

@synthesize imageButtons    = _imageButtons;
@synthesize delegate        = _delegate;


//----------------------------------------------------------------------------------------------------
- (id)initWithStyle:(UITableViewCellStyle)style 
	reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style
				reuseIdentifier:reuseIdentifier];
	
    if (self) {
        self.contentView.clipsToBounds = YES;
        self.imageButtons = [NSMutableArray arrayWithCapacity:kColumnsInPurchaseSearch];
        
        [self createImageButtons];
		
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
        UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(150*i + 10, 0, 150, 150)];
        
        imageButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageButton.backgroundColor = [UIColor yellowColor];
        
         [imageButton addTarget:self
         action:@selector(didTapImageButton:)
         forControlEvents:UIControlEventTouchUpInside];
        
        [self.imageButtons addObject:imageButton];
        
        [self.contentView addSubview:imageButton];
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
}

//----------------------------------------------------------------------------------------------------
- (void)setPurchaseImage:(UIImage*)image 
                forIndex:(NSInteger)index 
          withPurchaseID:(NSInteger)purchaseID {
    
    if(index >= [self.imageButtons count])
        return;
    
    UIButton *imageButton = [self.imageButtons objectAtIndex:index];
    
    imageButton.tag = purchaseID;
    
    [imageButton setImage:image
                 forState:UIControlStateNormal];
    
    [imageButton setImage:image
                 forState:UIControlStateHighlighted];
    
    imageButton.hidden = NO;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UI Events

//----------------------------------------------------------------------------------------------------
- (void)didTapImageButton:(UIButton*)button {
    [self.delegate purchaseClicked:button.tag];
}

@end
