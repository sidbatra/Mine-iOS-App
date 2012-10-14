//
//  DWNotificationsController.m
//  Mine
//
//  Created by Siddharth Batra on 10/14/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWNotificationsController.h"


#import "DWRequestManager.h"
#import "DWNotification.h"
#import "DWConstants.h"


static NSString* const kGetURI = @"/notifications.json?";

static NSString* const kNNotificationsLoaded       = @"NNotificationsLoaded";
static NSString* const kNNotificationsLoadError    = @"NNotificationsLoadError";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWNotificationsController

@synthesize delegate = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(notificationsLoaded:)
													 name:kNNotificationsLoaded
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(notificationsLoadError:)
													 name:kNNotificationsLoadError
												   object:nil];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    DWDebug(@"Notifications controller released");
}

//----------------------------------------------------------------------------------------------------
- (void)getNotifications {
    
    [[DWRequestManager sharedDWRequestManager] createAppRequest:kGetURI
                                            successNotification:kNNotificationsLoaded
                                              errorNotification:kNNotificationsLoadError
                                                  requestMethod:kGet
                                                   authenticate:YES];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)notificationsLoaded:(NSNotification*)notification {
    
    SEL sel = @selector(notificationsLoaded:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    
    NSDictionary *info          = [notification userInfo];
    NSDictionary *response      = [info objectForKey:kKeyResponse];
    NSMutableArray *notifications = [NSMutableArray arrayWithCapacity:[response count]];
    
    for(NSDictionary *notification in response) {
        [notifications addObject:[DWNotification create:notification]];
    }
    
    [self.delegate performSelector:sel
                        withObject:notifications];
}

//----------------------------------------------------------------------------------------------------
- (void)notificationsLoadError:(NSNotification*)notification {
    
    SEL sel = @selector(notificationsLoadError:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    
    NSDictionary *info  = [notification userInfo];
    NSError *error      = [info objectForKey:kKeyError];
    
    [self.delegate performSelector:sel
                        withObject:[error localizedDescription]];
}

@end
