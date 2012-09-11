//
//  DWStoreCell.m
//  Mine
//
//  Created by Deepak Rao on 9/10/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWStoreCell.h"

static NSString* const kImgBorder  = @"hr-D6D6D6.png";

@interface DWStoreCell() {
    UILabel         *storeNameLabel;
    UIImageView     *borderImageView;
}

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWStoreCell

//----------------------------------------------------------------------------------------------------
- (id)initWithStyle:(UITableViewCellStyle)style 
	reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style
				reuseIdentifier:reuseIdentifier];
	
    if (self) {
        self.contentView.clipsToBounds = YES;
		self.selectionStyle = UITableViewCellSelectionStyleGray;	
        
        self.contentView.backgroundColor = [UIColor colorWithRed:0.9333 green:0.9333 blue:0.9333 alpha:1.0];
        
        [self createStoreNameLabel];  
        [self createBorderImageView];
	}
	
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)createStoreNameLabel {
    storeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(11,0,288,44)];
    
    storeNameLabel.numberOfLines       = 1;
    storeNameLabel.backgroundColor     = [UIColor clearColor];
    storeNameLabel.font                = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
    storeNameLabel.textColor           = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    storeNameLabel.textAlignment       = UITextAlignmentLeft;
    
    [self.contentView addSubview:storeNameLabel];
}

//----------------------------------------------------------------------------------------------------
- (void)createBorderImageView {
    borderImageView         = [[UIImageView alloc] initWithFrame:CGRectMake(0, 43, 320, 1)];
    borderImageView.image   = [UIImage imageNamed:kImgBorder];
    
    [self.contentView addSubview:borderImageView];
}

//----------------------------------------------------------------------------------------------------
- (void)setStoreName:(NSString *)storeName {
    storeNameLabel.text = storeName;
}

@end

