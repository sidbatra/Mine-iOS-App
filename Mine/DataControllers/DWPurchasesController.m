//
//  DWPurchasesController.m
//  Mine
//
//  Created by Siddharth Batra on 7/26/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWPurchasesController.h"
#import "DWRequestManager.h"
#import "DWPurchase.h"
#import "DWConstants.h"

static NSString* const kGetUserPurchasesURI = @"/purchases.json?per_page=%d&user_id=%d";

static NSString* const kNUserPurchasesLoaded     = @"NUserPurchasesLoaded";
static NSString* const kNUserPurchasesLoadError  = @"NUserPurchasesLoadError";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWPurchasesController

@synthesize delegate = _delegate;


//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(userPurchasesLoaded:) 
													 name:kNUserPurchasesLoaded
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(userPurchasesLoadError:) 
													 name:kNUserPurchasesLoadError
												   object:nil];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"Purchases controller released");
}

//----------------------------------------------------------------------------------------------------
- (void)getPurchasesForUser:(NSInteger)userID 
                     before:(NSInteger)before {
    
    NSMutableString *localURL = [NSMutableString stringWithFormat:kGetUserPurchasesURI,10,userID];
    
    if(before != 0)
        [localURL appendFormat:@"&before=%d",before];
    
    [[DWRequestManager sharedDWRequestManager] createAppRequest:localURL
                                            successNotification:kNUserPurchasesLoaded
                                              errorNotification:kNUserPurchasesLoadError
                                                  requestMethod:kGet
                                                   authenticate:YES
                                                     resourceID:userID];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)userPurchasesLoaded:(NSNotification*)notification {
    
    SEL sel = @selector(purchasesLoaded:forUser:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    
    NSDictionary *info          = [notification userInfo];
    NSArray *response           = [info objectForKey:kKeyResponse];
    
    NSMutableArray *purchases   = [NSMutableArray arrayWithCapacity:[response count]];
    
    for(NSDictionary *purchase in response) {
        [purchases addObject:[DWPurchase create:purchase]];
    }
    
    [self.delegate performSelector:sel
                        withObject:purchases
                        withObject:[info objectForKey:kKeyResourceID]];
}

//----------------------------------------------------------------------------------------------------
- (void)userPurchasesLoadError:(NSNotification*)notification {
    
    SEL sel = @selector(purchasesLoadError:forUser:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
        
    NSDictionary *info      = [notification userInfo];
    NSError *error          = [info objectForKey:kKeyError];
    
    [self.delegate performSelector:sel
                        withObject:[error localizedDescription]
                        withObject:[info objectForKey:kKeyResourceID]];
}

@end
