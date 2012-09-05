//
//  DWProductCell.m
//  Mine
//
//  Created by Deepak Rao on 7/31/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWProductCell.h"
#import "DWConstants.h"

/**
 *
 */
NSInteger const kProductCellHeight = 102;

static NSString* const kImgProductBackground = @"chooser-item-bg-off@2x.png";
static NSString* const kImgProductHighlight  = @"chooser-item-bg-on@2x.png";


@interface DWProductCell() {
    NSMutableArray  *_productButtons;
}

/**
 * Product image buttons for displaying multiple products in a row
 */
@property (nonatomic,strong) NSMutableArray *productButtons;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWProductCell

@synthesize productButtons  = _productButtons;
@synthesize delegate        = _delegate;


//----------------------------------------------------------------------------------------------------
- (id)initWithStyle:(UITableViewCellStyle)style 
	reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style
				reuseIdentifier:reuseIdentifier];
	
    if (self) {
        self.contentView.clipsToBounds = YES;
        self.productButtons = [NSMutableArray arrayWithCapacity:kColumnsInProductsSearch];
        
        [self createProductButtons];
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;	
	}
	
    return self;
}

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Sub view creation

//----------------------------------------------------------------------------------------------------
- (void)createProductButtons {
    
    for(NSInteger i=0 ; i<kColumnsInProductsSearch ; i++) {
        UIButton *productButton = [[UIButton alloc] initWithFrame:CGRectMake(102*i, 8, 94, 94)];
        
        productButton.backgroundColor               = [UIColor clearColor];
        productButton.imageView.contentMode         = UIViewContentModeScaleAspectFit;
        productButton.imageEdgeInsets               = UIEdgeInsetsMake(7, 7, 7, 7);
        productButton.adjustsImageWhenHighlighted   = NO;
        
        [productButton setBackgroundImage:[UIImage imageNamed:kImgProductBackground] 
                                 forState:UIControlStateNormal];

        [productButton addTarget:self
                           action:@selector(didTapProductButton:)
                 forControlEvents:UIControlEventTouchUpInside];
        
        [productButton addTarget:self
                          action:@selector(highlightProductButton:)
                forControlEvents:UIControlEventTouchDown];
        
        [productButton addTarget:self
                          action:@selector(highlightProductButton:)
                forControlEvents:UIControlEventTouchDragEnter];
        
        [productButton addTarget:self
                          action:@selector(removeHighlightFromProductButton:)
                forControlEvents:UIControlEventTouchDragExit];        
        
        [self.productButtons addObject:productButton];
        
        [self.contentView addSubview:productButton];
    }
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UI Events

//----------------------------------------------------------------------------------------------------
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.delegate productCellTouched];
}

//----------------------------------------------------------------------------------------------------
- (void)didTapProductButton:(UIButton*)button {
    SEL sel = @selector(productClicked:);
    
    if(![self.delegate respondsToSelector:sel])
        return;

    [self.delegate performSelector:sel
                        withObject:[NSNumber numberWithInteger:button.tag]];
    
    [self performSelector:@selector(removeHighlightFromProductButton:) 
               withObject:button];
}

//----------------------------------------------------------------------------------------------------
- (void)highlightProductButton:(UIButton*)button {        
    
    UIImageView *imageView  = [[UIImageView alloc] initWithFrame:button.bounds];
    imageView.image         = [UIImage imageNamed:kImgProductHighlight];
    imageView.tag           = 1000;
    
    [button addSubview:imageView];
}

//----------------------------------------------------------------------------------------------------
- (void)removeHighlightFromProductButton:(UIButton*)button {
    
    UIView *view = [button viewWithTag:1000];
    [UIView animateWithDuration:0.2 animations:^{
        view.alpha = 0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];        
    }];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Accessor methods to populate cell UI

//----------------------------------------------------------------------------------------------------
- (void)resetUI {
    
    for(UIButton *productButton in self.productButtons) 
        productButton.hidden = YES;
    
}

//----------------------------------------------------------------------------------------------------
- (void)setProductImage:(UIImage*)image
       forButtonAtIndex:(NSInteger)index 
           andProductID:(NSInteger)productID {

    if(index >= [self.productButtons count])
        return;
    
    UIButton *productButton = [self.productButtons objectAtIndex:index];

    productButton.tag = productID;
    
    [productButton setImage:image
                    forState:UIControlStateNormal];
    
    productButton.hidden = NO;
}

@end

