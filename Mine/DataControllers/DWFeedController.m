//
//  DWFeedController.m
//  Mine
//
//  Created by Siddharth Batra on 7/21/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWFeedController.h"

#import "DWRequestManager.h"
#import "DWPurchase.h"
#import "DWConstants.h"

static NSString* const kGetURI = @"/feed.json?per_page=%d";


static NSString* const kNFeedLoaded     = @"NFeedLoaded";
static NSString* const kNFeedLoadError  = @"NFeedLoadError";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWFeedController

@synthesize delegate = _delegate;


//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(feedLoaded:) 
													 name:kNFeedLoaded
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(feedLoadError:) 
													 name:kNFeedLoadError
												   object:nil];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"Feed controller released");
}


//----------------------------------------------------------------------------------------------------
- (void)getPurchasesBefore:(NSTimeInterval)before {
    NSString *localURL = [NSString stringWithFormat:kGetURI,10];
    
    [[DWRequestManager sharedDWRequestManager] createAppRequest:localURL
                                            successNotification:kNFeedLoaded
                                              errorNotification:kNFeedLoadError
                                                  requestMethod:kGet
                                                   authenticate:YES];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)feedLoaded:(NSNotification*)notification {
    
    SEL sel = @selector(feedLoaded:);
    
    NSArray *response           = [[notification userInfo] objectForKey:kKeyResponse];
    NSMutableArray *purchases   = [NSMutableArray arrayWithCapacity:[response count]];
    
    for(NSDictionary *purchase in response) {
        [purchases addObject:[DWPurchase create:purchase]];
    }

    [self.delegate performSelector:sel
                        withObject:purchases];
}

//----------------------------------------------------------------------------------------------------
- (void)feedLoadError:(NSNotification*)notification {
    
    SEL sel = @selector(feedLoadError:);
    
    NSError *error = [[notification userInfo] objectForKey:kKeyError];
    
    [self.delegate performSelector:sel 
                        withObject:[error localizedDescription]];
}


@end
