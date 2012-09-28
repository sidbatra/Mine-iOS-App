//
//  DWQueueProgressView.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWQueueProgressView.h"
#import "DWConstants.h"

static float const kMinimumProgress         = 0.001;
static NSString* const kImgDelete           = @"post_cancel.png";
static NSString* const kImgRetry            = @"post_retry.png";
static NSString* const kImgProgress         = @"nav-convex-bg.png";
static NSString* const kImgProgressShadow   = @"nav-progress-shadow.png";
static NSString* const kImgBackground       = @"nav-concave-bg.png";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWQueueProgressView

@synthesize delegate = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
	if (self) {
        self.backgroundColor            = [UIColor clearColor];
        
        CALayer *backgroundLayer        = [CALayer layer];
        backgroundLayer.frame           = CGRectMake(0,0,self.frame.size.width,self.frame.size.height);
        backgroundLayer.contents        = (id)[UIImage imageNamed:kImgBackground].CGImage;
        [self.layer addSublayer:backgroundLayer];
        
        progressLayer                   = [CALayer layer];
        progressLayer.actions			= [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           [NSNull null], @"hidden",
                                           nil];
        progressLayer.contents          = (id)[UIImage imageNamed:kImgProgress].CGImage;
        [self.layer addSublayer:progressLayer];            
        
        //progressShadowLayer             = [CALayer layer];
        //progressShadowLayer.actions     = [NSMutableDictionary dictionaryWithObjectsAndKeys:
        //                                   [NSNull null], @"hidden",
        //                                   nil];
        //progressShadowLayer.contents    = (id)[UIImage imageNamed:kImgProgressShadow].CGImage;
        //[self.layer addSublayer:progressShadowLayer];
                                           
                                           
        
		statusLabel					= [[UILabel alloc] initWithFrame:CGRectMake(0,12,self.frame.size.width,20)];
        statusLabel.text            = @"Posting...";
		statusLabel.font			= [UIFont fontWithName:@"HelveticaNeue" size:15];
		statusLabel.textColor		= [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
		statusLabel.backgroundColor	= [UIColor clearColor];
		statusLabel.textAlignment	= UITextAlignmentCenter;
        statusLabel.shadowColor     = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.48];
        statusLabel.shadowOffset    = CGSizeMake(0, 1);
		[self addSubview:statusLabel];
		
		deleteButton					= [UIButton buttonWithType:UIButtonTypeCustom];
		deleteButton.frame				= CGRectMake(21,13,13,15);
		deleteButton.hidden				= YES;
		
        [deleteButton setBackgroundImage:[UIImage imageNamed:kImgDelete]
                                forState:UIControlStateNormal];
        
		[deleteButton setTitle:@"Delete"
					  forState:UIControlStateNormal];
		
		[deleteButton addTarget:self
						 action:@selector(didTapDeleteButton:)
			   forControlEvents:UIControlEventTouchUpInside];
		
		
		[self addSubview:deleteButton];
		
		
		retryButton						= [UIButton buttonWithType:UIButtonTypeCustom];
		retryButton.frame				= CGRectMake(166,13,13,15);
		retryButton.hidden				= YES;
        
        [retryButton setBackgroundImage:[UIImage imageNamed:kImgRetry]
                               forState:UIControlStateNormal];
		
		[retryButton setTitle:@"Retry"
					 forState:UIControlStateNormal];
		
		[retryButton addTarget:self
						 action:@selector(didTapRetryButton:)
			   forControlEvents:UIControlEventTouchUpInside];
		
		[self addSubview:retryButton];
    }
	
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)updateProgressBar:(float)progress 
            withAnimation:(BOOL)animation {
    
    [CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:animation && progress > kMinimumProgress ? 0.3f : 0.0f] 
					 forKey:kCATransactionAnimationDuration];
    
    progressLayer.frame = CGRectMake(0,0,self.frame.size.width*progress,self.frame.size.height);
    //progressShadowLayer.frame = CGRectMake(progressLayer.frame.size.width,0,5,self.frame.size.height);
    
    [CATransaction commit];
}

//----------------------------------------------------------------------------------------------------
- (void)updateDisplayWithTotalActive:(NSInteger)totalActive
						 totalFailed:(NSInteger)totalFailed 
					   totalProgress:(float)totalProgress {
	
	if(totalActive) {
        statusLabel.alpha       = 1.0;
		deleteButton.hidden		= YES;
		retryButton.hidden		= YES;
		progressLayer.hidden	= NO;
        //progressShadowLayer.hidden = NO;
		
        [self updateProgressBar:totalProgress
                  withAnimation:YES];
		
		if(totalActive == 1 && totalProgress < kMinimumProgress) {
			statusLabel.text = @"Connecting...";
		}
		else if(totalActive == 1)
			statusLabel.text = @"Posting...";
		else {
			statusLabel.text = [NSString stringWithFormat:@"Posting %d of %d",totalActive,totalActive];
		}
	}
	else if(totalFailed) {
        statusLabel.alpha       = 0.5;
		statusLabel.text		= totalFailed == 1 ? @"Failed" : [NSString stringWithFormat:@"%d failed",totalFailed];
		progressLayer.hidden	= YES;
        //progressShadowLayer.hidden = YES;
		deleteButton.hidden		= NO;
		retryButton.hidden		= NO;
	}
}

//----------------------------------------------------------------------------------------------------
- (void)didTapDeleteButton:(UIButton*)button {
	[_delegate deleteButtonPressed];
}

//----------------------------------------------------------------------------------------------------
- (void)didTapRetryButton:(UIButton*)button {
    
    [self updateProgressBar:0
              withAnimation:NO];    
    
    statusLabel.alpha       = 1.0;
	statusLabel.text		= @"";
	deleteButton.hidden		= YES;
	retryButton.hidden		= YES;
	progressLayer.hidden	= NO;
    //progressShadowLayer.hidden = NO;
	
	[_delegate retryButtonPressed];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors
//----------------------------------------------------------------------------------------------------
- (void)shouldBeRemovedFromNav {
   
}

@end
