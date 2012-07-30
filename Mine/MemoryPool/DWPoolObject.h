//
//  DWPoolObject.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * PoolObject is a mandatory base class for all
 * models that are added to the memory pool
 */
@interface DWPoolObject : NSObject {
	NSInteger	_databaseID;
	NSInteger	_pointerCount;
}

/**
 * Factory method for creating DWPoolObjects
 */
+ (id)create:(NSDictionary *)objectJSON;

/**
 * Fetch the object of the current class with the given objectID
 */
+ (id)fetch:(NSInteger)objectID;


/**
 * Primary key / unique id to uniquely identify the object
 */
@property (nonatomic,assign) NSInteger databaseID;


/**
 * Mount a pool object onto to the memory pool if the memory allocation
 * wasn't done via the pool
 */
- (void)mount;

/**
 * Template method overriden by the children classes
 * to update their contents via a JSON dictionary
 */
- (void)update:(NSDictionary*)objectJSON;

/**
 * Template method overriden by the children classes to free
 * any non critical memory
 */
- (void)freeMemory;

/**
 * Decreases the pointer count and releases the object if
 * there are no more references left
 */
- (void)destroy;

/**
 * Increment point count by one - imply an extra reference which wasn't done
 * via the convential create or mount methods.
 */
- (void)incrementPointerCount;

@end
