//
//  DWBackgroundQueue.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWBackgroundQueue.h"

#import "SynthesizeSingleton.h"

NSString* const kNBackgroundQueueUpdated    = @"BackgroundQueueUpdated";
NSString* const kKeyTotalActive             = @"total_active";
NSString* const kKeyTotalFailed             = @"total_failed";
NSString* const kKeyTotalProgress           = @"total_progress";


static float kFinalPostUpdateDelay	= 0.5;


@interface DWBackgroundQueue() {
    
}

/**
 * Broadcast status of the queue.
 */
- (void)postUpdate;
@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWBackgroundQueue

@synthesize queue = _queue;

SYNTHESIZE_SINGLETON_FOR_CLASS(DWBackgroundQueue);

//----------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	
	if(self) {
		self.queue = [NSMutableArray array];
	}
	
	return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {	
}

//----------------------------------------------------------------------------------------------------
- (void)addQueueItem:(DWBackgroundQueueItem*)queueItem {
    queueItem.delegate = self;
    
    [self.queue addObject:queueItem];
    [queueItem start];
}

//----------------------------------------------------------------------------------------------------
- (void)postUpdate {
	NSInteger	totalActive		= 0;
	NSInteger	totalFailed		= 0;
	float		totalProgress	= 0.0;
	
	for(DWBackgroundQueueItem *item in self.queue) {
		if([item isActive]) {
			totalActive++;
			totalProgress += item.progress;
		}
		else if([item isFailed])
			totalFailed++;
	}
		
	if(totalActive)
		totalProgress /= totalActive;
	
    
	[[NSNotificationCenter defaultCenter] postNotificationName:kNBackgroundQueueUpdated 
														object:nil
													  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
																[NSNumber numberWithInt:totalActive],kKeyTotalActive,
																[NSNumber numberWithInt:totalFailed],kKeyTotalFailed,
																[NSNumber numberWithFloat:totalProgress],kKeyTotalProgress,
																 nil]];
}

//----------------------------------------------------------------------------------------------------
- (void)retryRequests {
	for(DWBackgroundQueueItem *item in self.queue) {
		if([item isFailed])
			[item start];
	}
}

//----------------------------------------------------------------------------------------------------
- (void)deleteRequests {
	for(DWBackgroundQueueItem *item in self.queue) {
		if([item isFailed])
			[self.queue removeObject:item];
	}
    
    [self postUpdate];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWBackgroundQueueItemDelegate

//----------------------------------------------------------------------------------------------------
- (void)backgroundQueueItemProgressed {
    [self postUpdate];
}

//----------------------------------------------------------------------------------------------------
- (void)backgroundQueueItemFinished:(DWBackgroundQueueItem *)backgroundQueueItem {
    [self.queue removeObject:backgroundQueueItem];	
	
	[self performSelector:@selector(postUpdate)
			   withObject:nil
			   afterDelay:kFinalPostUpdateDelay];
}

@end
