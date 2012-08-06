//
//  DWBackgroundQueue.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWBackgroundQueueItem.h"


/**
 * Queue for managing asynchronous simultaneous background requests.
 */
@interface DWBackgroundQueue : NSObject<DWBackgroundQueueItemDelegate> {
	NSMutableArray *_queue;
}

/**
 * The sole shared instance of the class
 */
+ (DWBackgroundQueue *)sharedDWBackgroundQueue;

/**
 * Queue of items being created simultaneously
 */
@property (nonatomic,strong) NSMutableArray *queue;


/**
 * Add a new item onto the queue and start processing it.
 */
- (void)addQueueItem:(DWBackgroundQueueItem*)queueItem;

/**
 * Delete all failed requests from the queue
 */
- (void)deleteRequests;

/**
 * Retry all failed requests
 */
- (void)retryRequests;

@end
