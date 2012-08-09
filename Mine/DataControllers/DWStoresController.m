//
//  DWStoresController.m
//  Mine
//
//  Created by Siddharth Batra on 8/1/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWStoresController.h"

#import "DWRequestManager.h"
#import "DWStore.h"

#import "DWConstants.h"


static NSString* const kGetStoresURI            = @"/stores.json?aspect=%@";

static NSString* const kStoresQuery             = @"name contains[cd] %@";

static NSString* const kNStoresLoaded           = @"NStoresLoaded";
static NSString* const kNStoresLoadError        = @"NStoresLoadError";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWStoresController

@synthesize delegate = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(storesLoaded:) 
													 name:kNStoresLoaded
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(storesLoadError:) 
													 name:kNStoresLoadError
												   object:nil];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"Stores controller released");
}

//----------------------------------------------------------------------------------------------------
- (void)getAllStores {
    
    NSMutableString *localURL = [NSMutableString stringWithFormat:kGetStoresURI,@"all"];
    
    [[DWRequestManager sharedDWRequestManager] createAppRequest:localURL
                                            successNotification:kNStoresLoaded
                                              errorNotification:kNStoresLoadError
                                                  requestMethod:kGet
                                                   authenticate:YES];
}

//----------------------------------------------------------------------------------------------------
- (void)getStoresForQuery:(NSString *)query 
                withCache:(NSArray *)stores {
    
    SEL sel = @selector(storesLoaded:fromQuery:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    NSMutableArray *results;
    
    if ([query length]) {
        NSPredicate *pred   = [NSPredicate predicateWithFormat:kStoresQuery,query];
        results             = [NSMutableArray arrayWithArray:[stores filteredArrayUsingPredicate:pred]];
    }
    else {
        results = [NSMutableArray arrayWithArray:stores];
    }
    
    [self.delegate performSelector:sel
                        withObject:results
                        withObject:query];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)storesLoaded:(NSNotification*)notification {
    
    SEL sel = @selector(storesLoaded:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    
    NSDictionary *info          = [notification userInfo];
    NSArray *response           = [info objectForKey:kKeyResponse];
    
    NSMutableArray *stores      = [NSMutableArray arrayWithCapacity:[response count]];
    
    for(NSDictionary *store in response) {
        [stores addObject:[DWStore create:store]];
    }
    
    [self.delegate performSelector:sel
                        withObject:stores];
}

//----------------------------------------------------------------------------------------------------
- (void)storesLoadError:(NSNotification*)notification {
    
    SEL sel = @selector(storesLoadError:withAspect:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    
    NSDictionary *info      = [notification userInfo];
    NSError *error          = [info objectForKey:kKeyError];
    
    [self.delegate performSelector:sel
                        withObject:[error localizedDescription]];
}

@end


