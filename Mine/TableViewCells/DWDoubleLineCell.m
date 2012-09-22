//
//  DWDoubleLineCell.m
//  Mine
//
//  Created by Deepak Rao on 7/27/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWDoubleLineCell.h"

static NSString* const kImgCheckMarkIcon			= @"check_mark_white.png";
static NSString* const kImgSeparatorLight           = @"hr-AECDDE.png";
static NSString* const kImgSeparatorDark            = @"hr-125980.png";


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWDoubleLineSelectedView

//----------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
    if (self) {
        self.opaque				= YES;
		self.backgroundColor	= [UIColor colorWithRed:0.0901 green:0.4352 blue:0.6274 alpha:1.0];
    }
    
    return self;
}

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWDoubleLineView

@synthesize firstLine		= _firstLine;
@synthesize secondLine      = _secondLine;
@synthesize isDarker        = _isDarker;

//----------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
    if (self) {
        self.opaque				= YES;
		self.backgroundColor	= [UIColor colorWithRed:0.8156 green:0.8862 blue:0.9254 alpha:1.0];
        self.isDarker           = NO;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
	self.firstLine		= nil;
	self.secondLine     = nil;
	
}

//----------------------------------------------------------------------------------------------------
- (void)drawFirstLine {
    [self.firstLine drawInRect:CGRectMake(11, 3, 306, 18) 
                      withFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15]
                 lineBreakMode:UILineBreakModeTailTruncation
                     alignment:UITextAlignmentLeft];    
}

//----------------------------------------------------------------------------------------------------
- (void)drawSecondLine {
    [self.secondLine drawInRect:CGRectMake(11, 20, 306, 18) 
                       withFont:[UIFont fontWithName:@"HelveticaNeue" size:15] 
                  lineBreakMode:UILineBreakModeTailTruncation
                      alignment:UITextAlignmentLeft];
}

//----------------------------------------------------------------------------------------------------
- (void)drawRect:(CGRect)rect {
	
    if (self.isDarker) {
        [[UIColor whiteColor] set];
        [self drawFirstLine];
        
        [[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5] set];
        [self drawSecondLine];
        
        [[UIImage imageNamed:kImgCheckMarkIcon] drawInRect:CGRectMake(285, 15, 13, 14)];
        [[UIImage imageNamed:kImgSeparatorDark] drawInRect:CGRectMake(0, 42, 320, 1)];        
    }
    else {
        _highlighted ? [[UIColor whiteColor] set] : [[UIColor colorWithRed:0.0901 green:0.4352 blue:0.6274 alpha:1.0] set];
        [self drawFirstLine]; 
        
        _highlighted ? [[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5] set] : [[UIColor colorWithRed:0.0901 green:0.4352 blue:0.6274 alpha:0.75] set];
        [self drawSecondLine];
        
        [[UIImage imageNamed:kImgSeparatorLight] drawInRect:CGRectMake(0, 42, 320, 1)];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)reset {
	_highlighted = NO;
}

//----------------------------------------------------------------------------------------------------
- (void)redisplay {
	[self setNeedsDisplay];
}

//----------------------------------------------------------------------------------------------------
- (void)setHighlighted:(BOOL)highlighted {
	_highlighted = highlighted;
	[self redisplay];
}

//----------------------------------------------------------------------------------------------------
- (void)removeHighlight:(id)sender {
	_highlighted = NO;
	[self redisplay];
}

//----------------------------------------------------------------------------------------------------
- (BOOL)isHighlighted {
    return _highlighted;
}

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWDoubleLineCell

@synthesize doubleLineView = _doubleLineView;

//----------------------------------------------------------------------------------------------------
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
	if (self) {
		
		CGRect frame = CGRectMake(0.0,0.0,self.contentView.bounds.size.width,self.contentView.bounds.size.height);
		
		self.doubleLineView = [[DWDoubleLineView alloc] initWithFrame:frame];
        self.doubleLineView.autoresizingMask	= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.doubleLineView.contentMode         = UIViewContentModeRedraw;
		
		[self.contentView addSubview:self.doubleLineView];
		
		self.selectedBackgroundView = [[DWDoubleLineSelectedView alloc] initWithFrame:frame];
		self.accessoryType			= UITableViewCellAccessoryNone;
    }
	
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)reset {
	[self.doubleLineView reset];
}

//----------------------------------------------------------------------------------------------------
- (void)setFirstLine:(NSString*)firstLine {
	self.doubleLineView.firstLine = firstLine;
	[self.doubleLineView redisplay];
	
}

//----------------------------------------------------------------------------------------------------
- (void)setSecondLine:(NSString *)secondLine {
	self.doubleLineView.secondLine = secondLine;
	[self.doubleLineView redisplay];
}

//----------------------------------------------------------------------------------------------------
- (void)turnOnDarkerState {
    self.doubleLineView.backgroundColor = [UIColor colorWithRed:0.0901 green:0.4352 blue:0.6274 alpha:1.0];
    self.doubleLineView.isDarker        = YES;
    self.selectionStyle                 = UITableViewCellAccessoryNone;
}

//----------------------------------------------------------------------------------------------------
- (void)redisplay {
	[self.doubleLineView redisplay];
}



@end
