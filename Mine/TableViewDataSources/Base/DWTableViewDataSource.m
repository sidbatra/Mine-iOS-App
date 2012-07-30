//
//  DWTableViewDataSource.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTableViewDataSource.h"
#import "DWConstants.h"

static NSInteger const kDefaultSections = 1;


/**
 * Select private methods and properties
 */
@interface DWTableViewDataSource()

/**
 * Load the next page of objects
 */
- (void)paginate;

/**
 * Returns the index in the objects array for the given object. NSNotFound if not found.
 */
- (NSInteger)indexForObject:(id)object;

/**
 * Add the given object into the given index
 * and instruct table view to display it with animation
 */
- (void)addObject:(id)object
          atIndex:(NSInteger)index
    withAnimation:(UITableViewRowAnimation)animation;

/**
 * Add the given object at the end of the array
 */
- (void)addObjectAtEnd:(id)object
         withAnimation:(UITableViewRowAnimation)animation;

@end




//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTableViewDataSource

@synthesize objects     = _objects;
@synthesize delegate    = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.objects = [NSMutableArray array];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(paginationCellReached:) 
													 name:kNPaginationCellReached
												   object:nil];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)clean {
    SEL destroySelector = @selector(destroy);
    
    for(id object in self.objects) {
        if([object respondsToSelector:destroySelector])
            [object performSelector:destroySelector];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [self clean];
}



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Retrieval

//----------------------------------------------------------------------------------------------------
- (NSInteger)totalSections {
    return kDefaultSections;
}

//----------------------------------------------------------------------------------------------------
- (NSInteger)totalObjectsForSection:(NSInteger)section {
    return [self.objects count];
}

//----------------------------------------------------------------------------------------------------
- (id)objectAtIndex:(NSInteger)index 
         forSection:(NSInteger)section {
    
    return index < [self.objects count] ? [self.objects objectAtIndex:index] : nil;
}

//----------------------------------------------------------------------------------------------------
- (NSInteger)indexForObject:(id)object {
    return [self.objects indexOfObject:object];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Modification

//----------------------------------------------------------------------------------------------------
- (void)addObject:(id)object 
          atIndex:(NSInteger)index
    withAnimation:(UITableViewRowAnimation)animation {
    
    [self.objects insertObject:object
                       atIndex:index];
    
    [self.delegate insertRowAtIndex:index 
                      withAnimation:animation];
}

//----------------------------------------------------------------------------------------------------
- (void)addObjectAtEnd:(id)object
         withAnimation:(UITableViewRowAnimation)animation {
    
    [self addObject:object
            atIndex:[self.objects count]
      withAnimation:animation];
}

//----------------------------------------------------------------------------------------------------
- (void)removeObject:(id)object 
       withAnimation:(UITableViewRowAnimation)animation {
    
    NSInteger index = [self indexForObject:object];
    
    if(index == NSNotFound)
        return;
    
    [self.objects removeObjectAtIndex:index];
    
    [self.delegate removeRowAtIndex:index 
                      withAnimation:animation];
    
    
    SEL sel = @selector(destroy);
    
    if([object respondsToSelector:sel])
        [object performSelector:sel];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Templates

//----------------------------------------------------------------------------------------------------
- (void)refreshInitiated {
    
}

//----------------------------------------------------------------------------------------------------
- (void)paginate {
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)paginationCellReached:(NSNotification*)notification {
    if([notification object] == self) {
        [self paginate];
    }
}

@end
