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

static NSString* const kImgProductBackground = @"chooser-item-bg-off.png";
static NSString* const kImgProductHighlight  = @"chooser-item-bg-on.png";


@interface DWProductCell() {
    NSMutableArray  *_productButtons;
    NSMutableArray  *_productImageViews;    
}

/**
 * Product image buttons for displaying multiple products in a row
 */
@property (nonatomic,strong) NSMutableArray *productButtons;
@property (nonatomic,strong) NSMutableArray *productImageViews;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWProductCell

@synthesize productButtons      = _productButtons;
@synthesize productImageViews   = _productImageViews;
@synthesize delegate            = _delegate;


//----------------------------------------------------------------------------------------------------
- (id)initWithStyle:(UITableViewCellStyle)style 
	reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style
				reuseIdentifier:reuseIdentifier];
	
    if (self) {
        self.contentView.clipsToBounds = YES;
        
        self.productButtons     = [NSMutableArray arrayWithCapacity:kColumnsInProductsSearch];
        self.productImageViews  = [NSMutableArray arrayWithCapacity:kColumnsInProductsSearch];
        
        [self createProductCells];
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;	
	}
	
    return self;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Sub view creation

//----------------------------------------------------------------------------------------------------
- (void)createProductCells {
    
    for(NSInteger i=0 ; i<kColumnsInProductsSearch ; i++) {
        
        UIImageView *productImageView       = [[UIImageView alloc] initWithFrame:CGRectMake(102*i + 18, 15, 80, 80)];
        productImageView.contentMode        = UIViewContentModeScaleAspectFit;
        productImageView.backgroundColor    = [UIColor whiteColor];
        
        [self.productImageViews addObject:productImageView];
        [self.contentView addSubview:productImageView];
        
                
        UIButton *productButton = [[UIButton alloc] initWithFrame:CGRectMake(102*i + 11, 8, 94, 94)];
        
        [productButton setBackgroundImage:[UIImage imageNamed:kImgProductBackground] 
                                 forState:UIControlStateNormal];

        [productButton setBackgroundImage:[UIImage imageNamed:kImgProductHighlight] 
                                 forState:UIControlStateHighlighted];

        [productButton addTarget:self
                           action:@selector(didTapProductButton:)
                 forControlEvents:UIControlEventTouchUpInside];
        
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
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Accessor methods to populate cell UI

//----------------------------------------------------------------------------------------------------
- (void)resetUI {        
    
    for(UIButton *productButton in self.productButtons) 
        productButton.hidden = YES;
    
    for(UIImageView *productImageView in self.productImageViews) 
        productImageView.image = nil;
    
}

//----------------------------------------------------------------------------------------------------
- (void)setProductImage:(UIImage*)image
       forButtonAtIndex:(NSInteger)index 
           andProductID:(NSInteger)productID {

    if(index >= [self.productButtons count])
        return;
    
    UIButton *productButton = [self.productButtons objectAtIndex:index];
    productButton.tag       = productID;
    
    UIImageView *productImageView   = [self.productImageViews objectAtIndex:index];
    productImageView.image          = image;
    
    productButton.hidden = NO;
}

@end

