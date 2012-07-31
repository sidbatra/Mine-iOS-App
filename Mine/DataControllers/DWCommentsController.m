//
//  DWCommentsController.m
//  Mine
//
//  Created by Siddharth Batra on 7/31/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWCommentsController.h"

#import "DWComment.h"
#import "DWRequestManager.h"
#import "DWConstants.h"


static NSString* const kCreateURI = @"/comments.json?purchase_id=%d&message=%@";

static NSString* const kNCommentCreated        = @"NCommentCreated";
static NSString* const kNCommentCreateError    = @"NCommentCreateError";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWCommentsController

@synthesize delegate = _delegate;


//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(commentCreated:) 
													 name:kNCommentCreated
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(commentCreateError:) 
													 name:kNCommentCreateError
												   object:nil];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"Comments controller released");
}

//----------------------------------------------------------------------------------------------------
- (void)createCommentForPurchaseID:(NSInteger)purchaseID 
                       withMessage:(NSString*)message {
    
    NSMutableString *localURL = [NSMutableString stringWithFormat:kCreateURI,purchaseID,message];
    
    [[DWRequestManager sharedDWRequestManager] createAppRequest:localURL
                                            successNotification:kNCommentCreated
                                              errorNotification:kNCommentCreateError
                                                  requestMethod:kPost
                                                   authenticate:YES
                                                     resourceID:purchaseID];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)commentCreated:(NSNotification*)notification {
    
    SEL sel = @selector(commentCreated:forPurchaseID:);
    
    NSDictionary *info          = [notification userInfo];
    NSDictionary *response      = [info objectForKey:kKeyResponse];
    
    DWComment *comment          = [DWComment create:response];
    
    [self.delegate performSelector:sel
                        withObject:comment
                        withObject:[info objectForKey:kKeyResourceID]];
}

//----------------------------------------------------------------------------------------------------
- (void)commentCreateError:(NSNotification*)notification {
    
    SEL sel = @selector(commentCreateError:forPurchaseID:);
    
    NSDictionary *info  = [notification userInfo];
    NSError *error      = [info objectForKey:kKeyError];
    
    [self.delegate performSelector:sel 
                        withObject:[error localizedDescription]
                        withObject:[info objectForKey:kKeyResourceID]];
}
@end
