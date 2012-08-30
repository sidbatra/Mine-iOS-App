//
//  DWNavigationBarTitleView.m
//  Mine
//
//  Created by Siddharth Batra on 8/30/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWNavigationBarTitleView.h"

@interface DWNavigationBarTitleView() {
    UIImageView     *_imageView;
}

@property (nonatomic,strong) UIImageView *imageView;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWNavigationBarTitleView

@synthesize imageView = _imageView;

//----------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame 
       andImageName:(NSString*)imageName {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.imageView.image = [UIImage imageNamed:imageName];
        
        [self addSubview:self.imageView];
    }
    
    return self;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors
//----------------------------------------------------------------------------------------------------
- (void)shouldBeRemovedFromNav {
    
}


@end
