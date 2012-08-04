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
NSInteger const kProductCellHeight = 100;


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
        UIButton *productButton = [[UIButton alloc] initWithFrame:CGRectMake(100*i + 15, 0, 100, 100)];
        
        productButton.backgroundColor = [UIColor redColor];
        
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

