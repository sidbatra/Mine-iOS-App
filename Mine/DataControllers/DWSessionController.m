//
//  DWSessionController.m
//  Mine
//
//  Created by Siddharth Batra on 9/29/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWSessionController.h"
#import "DWRequestManager.h"
#import "DWConstants.h"


static NSString* const kDestroyURI = @"/logout.json?forever=true";

static NSString* const kNSessionDestroyed       = @"NSessionDestroyed";
static NSString* const kNSessionDestroyError    = @"NSessionDestroyError";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWSessionController

@synthesize delegate = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(sessionDestroyed:)
													 name:kNSessionDestroyed
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(sessionDestroyError:)
													 name:kNSessionDestroyError
												   object:nil];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    DWDebug(@"Session controller released");
}

//----------------------------------------------------------------------------------------------------
- (void)destroyForever {
    
    [[DWRequestManager sharedDWRequestManager] createAppRequest:kDestroyURI
                                            successNotification:kNSessionDestroyed
                                              errorNotification:kNSessionDestroyError
                                                  requestMethod:kGet
                                                   authenticate:YES];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)sessionDestroyed:(NSNotification*)notification {
    
    SEL sel = @selector(sessionDestroyed);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    
    [self.delegate performSelector:sel];
}

//----------------------------------------------------------------------------------------------------
- (void)sessionDestroyError:(NSNotification*)notification {
    
    SEL sel = @selector(sessionDestroyError:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    
    NSDictionary *info  = [notification userInfo];
    NSError *error      = [info objectForKey:kKeyError];
    
    [self.delegate performSelector:sel
                        withObject:[error localizedDescription]];
}


@end
