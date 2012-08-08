//
//  DWStatusController.m
//  Mine
//
//  Created by Siddharth Batra on 8/7/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWStatusController.h"

#import "DWRequestManager.h"
#import "DWUser.h"
#import "DWConstants.h"


static NSString* const kGetURI = @"/status.json?";

static NSString* const kNStatusLoaded       = @"NStatusLoaded";
static NSString* const kNStatusLoadError    = @"NStatusLoadError";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWStatusController

@synthesize delegate = _delegate;


//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(statusLoaded:) 
													 name:kNStatusLoaded
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(statusLoadError:) 
													 name:kNStatusLoadError
												   object:nil];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"Status controller released");
}



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)statusLoaded:(NSNotification*)notification {
    
    SEL sel = @selector(statusLoaded:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    
    NSDictionary *info          = [notification userInfo];
    NSDictionary *response      = [info objectForKey:kKeyResponse];

    DWUser  *user = [DWUser create:response];
    
    
    [self.delegate performSelector:sel
                        withObject:user];
}

//----------------------------------------------------------------------------------------------------
- (void)statusLoadError:(NSNotification*)notification {
    
    SEL sel = @selector(statusLoadError:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    
    NSDictionary *info  = [notification userInfo];
    NSError *error      = [info objectForKey:kKeyError];
    
    [self.delegate performSelector:sel 
                        withObject:[error localizedDescription]];
}



@end
