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
#import "DWConstants.h"

static NSString* const kGetUserPurchasesURI = @"/purchases.json?per_page=%d&user_id=%d";
static NSString* const kCreateURI           = @"/purchases.json?";

static NSString* const kNUserPurchasesLoaded    = @"NUserPurchasesLoaded";
static NSString* const kNUserPurchasesLoadError = @"NUserPurchasesLoadError";
static NSString* const kNPurchaseCreated        = @"NPurchaseCreated";
static NSString* const kNPurchaseCreateError    = @"NPurchaseCreateError";


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
												 selector:@selector(userPurchasesLoaded:) 
													 name:kNUserPurchasesLoaded
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(userPurchasesLoadError:) 
													 name:kNUserPurchasesLoadError
												   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(purchaseCreated:) 
													 name:kNPurchaseCreated
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(purchaseCreateError:) 
													 name:kNPurchaseCreateError
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
- (NSString*)purchasePostParam:(NSString*)name {
    return [NSString stringWithFormat:@"purchase[%@]",name];
}

//----------------------------------------------------------------------------------------------------
- (NSString*)purchasePostSubParam:(NSString*)subParam
                    withParamName:(NSString*)name {
    return [NSString stringWithFormat:@"%@[%@]",[self purchasePostParam:subParam],name];
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
@end
