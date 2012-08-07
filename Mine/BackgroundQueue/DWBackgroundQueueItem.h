//
//  DWBackgroundQueueItem.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DWBackgroundQueueItemDelegate;


/**
 * Base class for all items added onto the 
 * background queue
 */
@interface DWBackgroundQueueItem : NSObject {
    NSInteger   _resourceID;	
    NSInteger	_retries;
	NSInteger	_state;
    
	float		_progress;

    BOOL        _silent;
	
	NSString	*_errorMessage;
    
    __weak id<DWBackgroundQueueItemDelegate,NSObject> _delegate;
}

/**
 * Resource ID for the background request
 */
@property (nonatomic,assign) NSInteger resourceID;

/**
 * Number of retries used.
 */
@property (nonatomic,assign) NSInteger retries;

/**
 * State of the item on the queue
 */
@property (nonatomic,assign) NSInteger state;

/**
 * Request progress on a scale of 0-1
 */
@property (nonatomic,assign) float progress;

/**
 * If the request is to be performed silently in the background.
 */
@property (nonatomic,assign) BOOL silent;

/**
 * Error message optionally specifies the reason
 * for failure
 */ 
@property (nonatomic,copy) NSString* errorMessage;

/**
 * Delegate for receiving updates about the item's progress.
 */
@property (nonatomic,weak) id<DWBackgroundQueueItemDelegate,NSObject> delegate;


/**
 * YES if the request is active.
 */
- (BOOL)isActive;

/**
 * YES if the request has failed.
 */
- (BOOL)isFailed;


/**
 * Template method for starting a task.
 */
- (void)start;

/**
 * Template method called when item finishes.
 */
- (void)processingFinished;

/**
 * Template method called when an item fails.
 */
- (void)processingError;

@end


/**
 * Delegate for DWBackgroundQueueItem.
 */
@protocol DWBackgroundQueueItemDelegate

@required

/**
 * Queue item makes progress.
 */
- (void)backgroundQueueItemProgressed;

/**
 * Queue item is finished.
 */
- (void)backgroundQueueItemFinished:(DWBackgroundQueueItem*)backgroundQueueItem;

@end


