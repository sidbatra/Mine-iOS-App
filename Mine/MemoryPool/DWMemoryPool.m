//
//  DWMemoryPool.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWMemoryPool.h"
#import "DWConstants.h"

#import "SynthesizeSingleton.h"


/**
 * Private method and property declarations
 */
@interface DWMemoryPool()

/**
 * Each keys in the dictionary is a dictionary 
 * that holds objects of a particular class indexed by their
 * primary ids
 */
@property (nonatomic) NSMutableDictionary *memoryPool;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWMemoryPool

@synthesize memoryPool = _memoryPool;

SYNTHESIZE_SINGLETON_FOR_CLASS(DWMemoryPool);

//----------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	
	if(self) {
		self.memoryPool = [NSMutableDictionary dictionary];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(lowMemoryState:) 
													 name:kNEnteringLowMemoryState
												   object:nil];
	}
	
	return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {	
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//----------------------------------------------------------------------------------------------------
- (id)getObjectWithID:(NSString*)objectID 
             forClass:(NSString*)className {
	
	NSMutableDictionary *pool = [self.memoryPool objectForKey:className];
	return [pool objectForKey:objectID];
}

//----------------------------------------------------------------------------------------------------
- (void)setObject:(id)object
           withID:(NSString*)objectID
         forClass:(NSString*)className {
    
	NSMutableDictionary *pool = [self.memoryPool objectForKey:className];
    
    if(!pool) {
        pool = [NSMutableDictionary dictionary];
        [self.memoryPool setObject:pool
                            forKey:className];
    }
	
	[pool setObject:object 
             forKey:objectID];
}

//----------------------------------------------------------------------------------------------------
- (void)removeObjectWithID:(NSString*)objectID 
                  forClass:(NSString*)className {

    NSMutableDictionary *pool = [self.memoryPool objectForKey:className];
    [pool removeObjectForKey:objectID];
}

//----------------------------------------------------------------------------------------------------
- (void)freeMemory {
    
    SEL sel = @selector(freeMemory);
    
    for(NSMutableDictionary *pool in [self.memoryPool allValues]) {
        
        for(id<NSObject> object in [pool allValues]) {            
            if([object respondsToSelector:sel])
                [object performSelector:sel];
        }
    }
}



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)lowMemoryState:(NSNotification*)notification {
    [self freeMemory];
}

@end
