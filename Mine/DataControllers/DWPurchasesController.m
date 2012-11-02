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
#import "DWProduct.h"
#import "DWStore.h"
#import "DWCryptography.h"
#import "DWConstants.h"

static NSString* const kGetPurchaseURI                  = @"/p/%@.json?";
static NSString* const kGetUserPurchasesURI             = @"/purchases.json?per_page=%d&user_id=%d";
static NSString* const kGetUnapprovedStalePurchasesURI  = @"/purchases.json?aspect=unapproved&per_page=%d";
static NSString* const kGetUnapprovedLivePurchasesURI   = @"/purchases.json?aspect=unapproved&per_page=%d&offset=%d&by_created_at=true";
static NSString* const kCreateURI                       = @"/purchases.json?";
static NSString* const kDeleteURI                       = @"/purchases/%d.json?";

static NSString* const kNPurchaseLoaded                 = @"NPurchaseLoaded";
static NSString* const kNPurchaseLoadError              = @"NPurchaseLoadError";
static NSString* const kNUserPurchasesLoaded            = @"NUserPurchasesLoaded";
static NSString* const kNUserPurchasesLoadError         = @"NUserPurchasesLoadError";
static NSString* const kNUnapprovedPurchasesLoaded      = @"NUnapprovedPurchasesLoaded";
static NSString* const kNUnapprovedPurchasesLoadError   = @"NUnapprovedPurchasesLoadError";
static NSString* const kNPurchaseCreated                = @"NPurchaseCreated";
static NSString* const kNPurchaseCreateError            = @"NPurchaseCreateError";
static NSString* const kNPurchaseDeleted                = @"NPurchaseDeleted";
static NSString* const kNPurchaseDeleteError            = @"NPurchaseDeleteError";


@interface DWPurchasesController() {
}

/**
 * Create post param for given name - "title" to "puchase[title]"
 */
- (NSString*)purchasePostParam:(NSString*)name;

/**
 * Create sub post params - "product","title" to "purchase[product][title]"
 */
- (NSString*)purchasePostSubParam:(NSString*)subParam
                    withParamName:(NSString*)name;

@end



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
												 selector:@selector(purchaseLoaded:)
													 name:kNPurchaseLoaded
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(purchaseLoadError:)
													 name:kNPurchaseLoadError
												   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(userPurchasesLoaded:) 
													 name:kNUserPurchasesLoaded
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(userPurchasesLoadError:) 
													 name:kNUserPurchasesLoadError
												   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(unapprovedPurchasesLoaded:)
													 name:kNUnapprovedPurchasesLoaded
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(unapprovedPurchasesLoadError:)
													 name:kNUnapprovedPurchasesLoadError
												   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(purchaseCreated:) 
													 name:kNPurchaseCreated
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(purchaseCreateError:) 
													 name:kNPurchaseCreateError
												   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(purchaseDeleted:) 
													 name:kNPurchaseDeleted
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(purchaseDeleteError:) 
													 name:kNPurchaseDeleteError
												   object:nil];        
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    DWDebug(@"Purchases controller released");
}

//----------------------------------------------------------------------------------------------------
- (NSString*)purchasePostParam:(NSString*)name {
    return [NSString stringWithFormat:@"purchase[%@]",name];
}

//----------------------------------------------------------------------------------------------------
- (NSString*)purchasePostSubParam:(NSString*)subParam
                    withParamName:(NSString*)name {
    return [NSString stringWithFormat:@"%@[%@]",[self purchasePostParam:subParam],name];
}

//----------------------------------------------------------------------------------------------------
- (void)getPurchase:(NSInteger)purchaseID {
    NSMutableString *localURL = [NSMutableString stringWithFormat:kGetPurchaseURI,[DWCryptography obfuscate:purchaseID]];
    
    [[DWRequestManager sharedDWRequestManager] createAppRequest:localURL
                                            successNotification:kNPurchaseLoaded
                                              errorNotification:kNPurchaseLoadError
                                                  requestMethod:kGet
                                                   authenticate:YES
                                                     resourceID:purchaseID];
}

//----------------------------------------------------------------------------------------------------
- (void)getPurchasesForUser:(NSInteger)userID 
                     before:(NSInteger)before
                 withCaller:(NSObject*)caller {

    NSMutableString *localURL = [NSMutableString stringWithFormat:kGetUserPurchasesURI,10,userID];
    
    if(before != 0)
        [localURL appendFormat:@"&before=%d",before];
    
    [[DWRequestManager sharedDWRequestManager] createAppRequest:localURL
                                            successNotification:kNUserPurchasesLoaded
                                              errorNotification:kNUserPurchasesLoadError
                                                  requestMethod:kGet
                                                   authenticate:YES
                                                     callerID:caller.hash];
}

//----------------------------------------------------------------------------------------------------
- (void)getUnapprovedStalePurchasesBefore:(NSInteger)before
                                  perPage:(NSInteger)perPage {
    
    NSMutableString *localURL = [NSMutableString stringWithFormat:kGetUnapprovedStalePurchasesURI,perPage];
    
    if(before != 0)
        [localURL appendFormat:@"&before=%d",before];
    
    [[DWRequestManager sharedDWRequestManager] createAppRequest:localURL
                                            successNotification:kNUnapprovedPurchasesLoaded
                                              errorNotification:kNUnapprovedPurchasesLoadError
                                                  requestMethod:kGet
                                                   authenticate:YES];
}

//----------------------------------------------------------------------------------------------------
- (void)getUnapprovedLivePurchasesAtOffset:(NSInteger)offset
                                   perPage:(NSInteger)perPage {
    
    NSMutableString *localURL = [NSMutableString stringWithFormat:kGetUnapprovedLivePurchasesURI,offset,perPage];
    
    [[DWRequestManager sharedDWRequestManager] createAppRequest:localURL
                                            successNotification:kNUnapprovedPurchasesLoaded
                                              errorNotification:kNUnapprovedPurchasesLoadError
                                                  requestMethod:kGet
                                                   authenticate:YES];
}

//----------------------------------------------------------------------------------------------------
- (NSInteger)createPurchaseFromTemplate:(DWPurchase*)purchase
                             andProduct:(DWProduct*)product
                          withShareToFB:(BOOL)shareToFB
                          withShareToTW:(BOOL)shareToTW
                          withShareToTB:(BOOL)shareToTB 
                         uploadDelegate:(id)uploadDelegate {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:purchase.origImageURL     forKey:[self purchasePostParam:kKeyOrigImageURL]];
    [params setObject:purchase.origThumbURL     forKey:[self purchasePostParam:kKeyOrigThumbURL]];
    [params setObject:purchase.title            forKey:[self purchasePostParam:kKeyTitle]];
    [params setObject:purchase.sourceURL        forKey:[self purchasePostParam:kKeySourceURL]];
    
    [params setObject:purchase.endorsement      forKey:[self purchasePostParam:kKeyEndorsement]];
    [params setObject:purchase.query            forKey:[self purchasePostParam:kKeyQuery]];
    
    [params setObject:product.title             forKey:[self purchasePostSubParam:kKeyProduct withParamName:kKeyTitle]];
    [params setObject:product.uniqueID          forKey:[self purchasePostSubParam:kKeyProduct withParamName:kKeyExternalID]];
    
    if(purchase.suggestionID) {
        [params setObject:[NSString stringWithFormat:@"%d",purchase.suggestionID] forKey:[self purchasePostParam:kKeySuggestionID]];
    }
    
    if(purchase.store) {
        [params setObject:purchase.store.name   forKey:[self purchasePostParam:kKeyStoreName]];
        [params setObject:@"0"                  forKey:[self purchasePostParam:kKeyIsStoreUnknown]];
    }
    else {
        [params setObject:@""                   forKey:[self purchasePostParam:kKeyStoreName]];
        [params setObject:@"1"                  forKey:[self purchasePostParam:kKeyIsStoreUnknown]];        
    }
    
    [params setObject:[NSString stringWithFormat:@"%d",shareToFB] forKey:[self purchasePostParam:kKeyShareToFB]];
    [params setObject:[NSString stringWithFormat:@"%d",shareToTW] forKey:[self purchasePostParam:kKeyShareToTW]];
    [params setObject:[NSString stringWithFormat:@"%d",shareToTB] forKey:[self purchasePostParam:kKeyShareToTB]];
    
    
    return [[DWRequestManager sharedDWRequestManager] createPostBodyBasedAppRequest:kCreateURI
                                                                         withParams:params
                                                                successNotification:kNPurchaseCreated 
                                                                  errorNotification:kNPurchaseCreateError
                                                                       authenticate:YES
                                                                     uploadDelegate:uploadDelegate];
}

//----------------------------------------------------------------------------------------------------
- (void)deletePurchaseWithID:(NSInteger)purchaseID {
    
    NSMutableString *localURL = [NSMutableString stringWithFormat:kDeleteURI,purchaseID];
    
    [[DWRequestManager sharedDWRequestManager] createAppRequest:localURL
                                            successNotification:kNPurchaseDeleted
                                              errorNotification:kNPurchaseDeleteError
                                                  requestMethod:kDelete
                                                   authenticate:YES
                                                     resourceID:purchaseID];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)purchaseLoaded:(NSNotification*)notification {
    
    SEL sel = @selector(purchaseLoaded:withResourceID:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    
    NSDictionary *info          = [notification userInfo];
    NSDictionary *response      = [info objectForKey:kKeyResponse];
    
    DWPurchase *purchase        = [DWPurchase create:response];
    
    [self.delegate performSelector:sel
                        withObject:purchase
                        withObject:[info objectForKey:kKeyResourceID]];
}

//----------------------------------------------------------------------------------------------------
- (void)purchaseLoadError:(NSNotification*)notification {
    
    SEL sel = @selector(purchaseLoadError:withResourceID:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    
    NSDictionary *info      = [notification userInfo];
    NSError *error          = [info objectForKey:kKeyError];
    
    [self.delegate performSelector:sel
                        withObject:[error localizedDescription]
                        withObject:[info objectForKey:kKeyResourceID]];
}

//----------------------------------------------------------------------------------------------------
- (void)userPurchasesLoaded:(NSNotification*)notification {

    NSDictionary *info = [notification userInfo];
    
    
    SEL sel = @selector(purchasesLoaded:);
    
    if(!self.delegate || self.delegate.hash != [[info objectForKey:kKeyCallerID] integerValue] || ![self.delegate respondsToSelector:sel])
        return;
    
    
    NSArray *response = [info objectForKey:kKeyResponse];
    NSMutableArray *purchases = [NSMutableArray arrayWithCapacity:[response count]];
    
    for(NSDictionary *purchase in response) {
        [purchases addObject:[DWPurchase create:purchase]];
    }
    
    [self.delegate performSelector:sel
                        withObject:purchases];
}

//----------------------------------------------------------------------------------------------------
- (void)userPurchasesLoadError:(NSNotification*)notification {
    
    NSDictionary *info = [notification userInfo];


    SEL sel = @selector(purchasesLoadError:);
    
    if(!self.delegate || self.delegate.hash != [[info objectForKey:kKeyCallerID] integerValue] || ![self.delegate respondsToSelector:sel])
        return;
    
        
    NSError *error = [info objectForKey:kKeyError];
    
    [self.delegate performSelector:sel
                        withObject:[error localizedDescription]];
}
//----------------------------------------------------------------------------------------------------
- (void)unapprovedPurchasesLoaded:(NSNotification*)notification {
    
    SEL sel = @selector(unapprovedPurchasesLoaded:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    
    NSArray *response = [[notification userInfo] objectForKey:kKeyResponse];
    NSMutableArray *purchases = [NSMutableArray arrayWithCapacity:[response count]];
    
    for(NSDictionary *purchase in response) {
        [purchases addObject:[DWPurchase create:purchase]];
    }
    
    [self.delegate performSelector:sel
                        withObject:purchases];
}

//----------------------------------------------------------------------------------------------------
- (void)unapprovedPurchasesLoadError:(NSNotification*)notification {
    
    SEL sel = @selector(unapprovedPurchasesLoadError:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    
    NSError *error = [[notification userInfo] objectForKey:kKeyError];
    
    [self.delegate performSelector:sel
                        withObject:[error localizedDescription]];
}

//----------------------------------------------------------------------------------------------------
- (void)purchaseCreated:(NSNotification*)notification {
    
    SEL sel = @selector(purchaseCreated:fromResourceID:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    
    NSDictionary *info          = [notification userInfo];
    NSDictionary *response      = [info objectForKey:kKeyResponse];
    
    DWPurchase *purchase        = [DWPurchase create:response];
    
    [self.delegate performSelector:sel
                        withObject:purchase
                        withObject:[info objectForKey:kKeyResourceID]];
}

//----------------------------------------------------------------------------------------------------
- (void)purchaseCreateError:(NSNotification*)notification {
    
    SEL sel = @selector(purchaseCreateError:fromResourceID:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    
    NSDictionary *info      = [notification userInfo];
    NSError *error          = [info objectForKey:kKeyError];
    
    [self.delegate performSelector:sel
                        withObject:[error localizedDescription]
                        withObject:[info objectForKey:kKeyResourceID]];
}

//----------------------------------------------------------------------------------------------------
- (void)purchaseDeleted:(NSNotification*)notification {
    
    SEL sel = @selector(purchaseDeleted:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    

    NSDictionary *info  = [notification userInfo];

    [self.delegate performSelector:sel
                        withObject:[info objectForKey:kKeyResourceID]];
}

//----------------------------------------------------------------------------------------------------
- (void)purchaseDeleteError:(NSNotification*)notification {
    
    SEL sel = @selector(purchaseDeleteError:fromResourceID:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    
    NSDictionary *info      = [notification userInfo];
    NSError *error          = [info objectForKey:kKeyError];
    
    [self.delegate performSelector:sel
                        withObject:[error localizedDescription] 
                        withObject:[info objectForKey:kKeyResourceID]];
}

@end
