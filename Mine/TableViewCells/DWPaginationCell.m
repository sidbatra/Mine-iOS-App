//
//  DWPaginationCell.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWPaginationCell.h"
#import "DWConstants.h"

NSInteger const kPaginationCellHeight = 60;

static NSInteger const kSpinnerSize = 20;

/**
 * Private declarations
 */
@interface DWPaginationCell() 

/**
 * Create the spinner inside the cell
 */
- (void) createSpinner;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWPaginationCell

//----------------------------------------------------------------------------------------------------
- (id)initWithStyle:(UITableViewCellStyle)style 
    reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.backgroundColor = [UIColor blackColor];
        
        [self createSpinner];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void) createSpinner {

    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]
                                            initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    //spinner.alpha   = 0.5;
	spinner.frame	= CGRectMake((self.contentView.frame.size.width - kSpinnerSize)/2,
                                 (kPaginationCellHeight - kSpinnerSize)/2,
                                 kSpinnerSize,
                                 kSpinnerSize);
    
    [spinner startAnimating];
	
	[self.contentView addSubview:spinner];	
}

@end
