//
//  DWBackgroundQueueItem.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWBackgroundQueueItem.h"
#import "DWConstants.h"

static NSInteger const kTotalRetries    = 5;
static float	 const kMaxProgress     = 1.0;


@interface DWBackgroundQueueItem() {
    
}

/**
 * Communicate progress via the delegate.
 */
- (void)communicateProgress;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWBackgroundQueueItem

@synthesize resourceID      = _resourceID;
@synthesize retries         = _retries;
@synthesize state			= _state;
@synthesize progress		= _progress;
@synthesize silent          = _silent;
@synthesize errorMessage	= _errorMessage;
@synthesize delegate        = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	
	if(self) {
        self.state = DWBackgroundQueueItemStateWaiting;
	}
	
	return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
}

//----------------------------------------------------------------------------------------------------
- (void)communicateProgress {
    [self.delegate backgroundQueueItemProgressed];
}

//----------------------------------------------------------------------------------------------------
- (BOOL)isActive {
	return (self.state == DWBackgroundQueueItemStateInProgress ||  
            self.state == DWBackgroundQueueItemStateWaiting) && !self.silent;
}

//----------------------------------------------------------------------------------------------------
- (BOOL)isFailed {
	return self.state == DWBackgroundQueueItemStateFailed;
}

//----------------------------------------------------------------------------------------------------
- (void)start {
    if(self.retries > kTotalRetries)
        self.retries = 0;
    
    self.state = DWBackgroundQueueItemStateInProgress;
    [self communicateProgress];
}

//----------------------------------------------------------------------------------------------------
- (void)processingFinished {
    self.progress = kMaxProgress;
    
	[self communicateProgress];
	
	self.state = DWBackgroundQueueItemStateDone;
	
	[self.delegate backgroundQueueItemFinished:self];
}

//----------------------------------------------------------------------------------------------------
- (void)processingError {
	if(self.retries++ < kTotalRetries)
		[self start];
	else {
		self.state = DWBackgroundQueueItemStateFailed;
		[self communicateProgress];
	}
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark ASIUploadProgressDelegate

//----------------------------------------------------------------------------------------------------
- (void)setProgress:(float)newProgress {
    _progress = newProgress;
	[self communicateProgress];
}


@end
