//
//  DWMemoryPool.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * DWMemoryPool abstracts a generic in-memory hash. Each class is assigned an 
 * entry in the hash which is in-turn a hash to store objects by unique ids.
 */
@interface DWMemoryPool : NSObject {
    NSMutableDictionary    *_memoryPool;
}

/**
 * The sole shared instance of the class
 */
+ (DWMemoryPool *)sharedDWMemoryPool;


/**
 * Retrieve an object belonging to a particular class
 * with the given ID
 */
- (id)getObjectWithID:(NSString*)objectID 
             forClass:(NSString*)className;

/**
 * Set the given object of a particular class
 * with the given ID
 */
- (void)setObject:(id)object
           withID:(NSString*)objectID
         forClass:(NSString*)className;

/**
 * Remove an object belonging to a particular class
 * with the given ID
 */
- (void)removeObjectWithID:(NSString*)objectID 
                  forClass:(NSString*)className;
/**
 * Free non critical memory from all the pool objects
 */
- (void)freeMemory;

@end

