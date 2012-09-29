//
//  DWPagination.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWPagination.h"
#import "DWConstants.h"


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWPagination

@synthesize isTriggered = _isTriggered;
@synthesize isDisabled  = _isDisabled;
@synthesize owner       = _owner;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    DWDebug(@"Pagination released");
}

@end
