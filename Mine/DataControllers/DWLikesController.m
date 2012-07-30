//
//  DWLikesController.m
//  Mine
//
//  Created by Siddharth Batra on 7/30/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWLikesController.h"

#import "DWLike.h"
#import "DWRequestManager.h"
#import "DWConstants.h"


static NSString* const kCreateURI = @"/likes.json?purchase_id=%d";

static NSString* const kNLikeCreated        = @"NLikeCreated";
static NSString* const kNLikeCreateError    = @"NLikeCreateError";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWLikesController

@synthesize delegate = _delegate;


//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(likeCreated:) 
													 name:kNLikeCreated
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(likeCreateError:) 
													 name:kNLikeCreateError
												   object:nil];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"Likes controller released");
}

//----------------------------------------------------------------------------------------------------
- (void)createLikeForPurchaseID:(NSInteger)purchaseID {
    NSMutableString *localURL = [NSMutableString stringWithFormat:kCreateURI,purchaseID];
    
    [[DWRequestManager sharedDWRequestManager] createAppRequest:localURL
                                            successNotification:kNLikeCreated
                                              errorNotification:kNLikeCreateError
                                                  requestMethod:kPost
                                                   authenticate:YES
                                                     resourceID:purchaseID];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)likeCreated:(NSNotification*)notification {
    
    SEL sel = @selector(likeCreated:forPurchaseID:);
    
    NSDictionary *info          = [notification userInfo];
    NSDictionary *response      = [info objectForKey:kKeyResponse];

    DWLike *like                = [DWLike create:response];
    
    [self.delegate performSelector:sel
                        withObject:like
                        withObject:[info objectForKey:kKeyResourceID]];
}

//----------------------------------------------------------------------------------------------------
- (void)likeCreateError:(NSNotification*)notification {
    
    SEL sel = @selector(likeCreateError:forPurchaseID:);
    
    NSDictionary *info  = [notification userInfo];
    NSError *error      = [info objectForKey:kKeyError];
    
    [self.delegate performSelector:sel 
                        withObject:[error localizedDescription]
                        withObject:[info objectForKey:kKeyResourceID]];
}

@end


