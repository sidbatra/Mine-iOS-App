//
//  DWSuggestionsController.m
//  Mine
//
//  Created by Deepak Rao on 8/14/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWSuggestionsController.h"

#import "DWRequestManager.h"
#import "DWSuggestion.h"
#import "DWConstants.h"

static NSString* const kGetURI = @"/suggestions.json?";


static NSString* const kNSuggestionsLoaded     = @"NSuggestionsLoaded";
static NSString* const kNSuggestionsLoadError  = @"NSuggestionsLoadError";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWSuggestionsController

@synthesize delegate = _delegate;


//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(suggestionsLoaded:) 
													 name:kNSuggestionsLoaded
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(suggestionsLoadError:) 
													 name:kNSuggestionsLoadError
												   object:nil];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"Suggestions controller released");
}

//----------------------------------------------------------------------------------------------------
- (void)getSuggestions {

    [[DWRequestManager sharedDWRequestManager] createAppRequest:kGetURI
                                            successNotification:kNSuggestionsLoaded
                                              errorNotification:kNSuggestionsLoadError
                                                  requestMethod:kGet
                                                   authenticate:YES];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)suggestionsLoaded:(NSNotification*)notification {
    
    SEL sel = @selector(suggestionsLoaded:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    NSArray *response               = [[notification userInfo] objectForKey:kKeyResponse];
    NSMutableArray *suggestions     = [NSMutableArray arrayWithCapacity:[response count]];
    
    for(NSDictionary *suggestion in response) {
        [suggestions addObject:[DWSuggestion create:suggestion]];
    }
    
    [self.delegate performSelector:sel
                        withObject:suggestions];
}

//----------------------------------------------------------------------------------------------------
- (void)suggestionsLoadError:(NSNotification*)notification {
    
    SEL sel = @selector(suggestionsLoadError:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    NSError *error = [[notification userInfo] objectForKey:kKeyError];
    
    [self.delegate performSelector:sel 
                        withObject:[error localizedDescription]];
}


@end

