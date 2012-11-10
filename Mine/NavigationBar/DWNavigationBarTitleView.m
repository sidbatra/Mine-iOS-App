//
//  DWNavigationBarTitleView.m
//  Mine
//
//  Created by Siddharth Batra on 8/30/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWNavigationBarTitleView.h"

static NSString* const kNavBarMineLogo = @"nav-mine-logo.png";


@interface DWNavigationBarTitleView() {
    UIImageView *_imageView;
    UILabel *_titleLabel;
    UIActivityIndicatorView *_spinnerView;
}

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIActivityIndicatorView *spinnerView;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWNavigationBarTitleView

@synthesize imageView = _imageView;
@synthesize titleLabel = _titleLabel;
@synthesize spinnerView = _spinnerView;

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
- (id)initWithFrame:(CGRect)frame
              title:(NSString*)title
         andSpinner:(BOOL)isSpinner {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.spinnerView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.spinnerView.frame	= CGRectMake(0,12,20,20);
        
        [self.spinnerView startAnimating];
        
        [self addSubview:self.spinnerView];
        

        
        self.titleLabel                      = [[UILabel alloc] initWithFrame:CGRectMake(self.spinnerView.frame.origin.x + self.spinnerView.frame.size.width + 8,
                                                                                         10,
                                                                                         self.frame.size.width-28,
                                                                                         25)];
        self.titleLabel.textColor            = [UIColor whiteColor];
        self.titleLabel.textAlignment        = UITextAlignmentLeft;
        self.titleLabel.backgroundColor      = [UIColor clearColor];
        self.titleLabel.shadowColor          = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.48];
        self.titleLabel.shadowOffset         = CGSizeMake(0, 1);
        self.titleLabel.font                 = [UIFont fontWithName:@"HelveticaNeue-Bold"
                                                          size:20];
        self.titleLabel.text                 = title;
        
        [self addSubview:self.titleLabel];
    }
    
    return self;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors

//----------------------------------------------------------------------------------------------------
+ (DWNavigationBarTitleView*)logoTitleView {
    return [[DWNavigationBarTitleView alloc] initWithFrame:CGRectMake(121,0,77,44)
                                              andImageName:kNavBarMineLogo];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors

//----------------------------------------------------------------------------------------------------
- (void)shouldBeRemovedFromNav {
    
}


@end
