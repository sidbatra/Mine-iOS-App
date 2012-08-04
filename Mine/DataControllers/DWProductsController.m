//
//  DWProductsController.m
//  Mine
//
//  Created by Deepak Rao on 7/30/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWProductsController.h"
#import "DWRequestManager.h"
#import "DWProduct.h"
#import "DWConstants.h"
#import "NSString+Helpers.h"

static NSString* const kGetProductsURI      = @"/products.json?q=%@&page=%d";

static NSString* const kNProductsLoaded     = @"NProductsLoaded";
static NSString* const kNProductsLoadError  = @"NProductsLoadError";

static NSString* const kKeyProducts         = @"products";
static NSString* const kKeyQuery            = @"query";
static NSString* const kKeySaneQuery        = @"sane_query";
static NSInteger const kMaxProductsPerPage  = 100;



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWProductsController

@synthesize delegate = _delegate;


//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(productsLoaded:) 
													 name:kNProductsLoaded
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(productsLoadError:) 
													 name:kNProductsLoadError
												   object:nil];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"Products controller released");
}

//----------------------------------------------------------------------------------------------------
- (void)getProductsForQuery:(NSString *)query 
                    andPage:(NSInteger)page {
    
    NSMutableString *localURL = [NSMutableString stringWithFormat:kGetProductsURI,[query stringByEncodingHTMLCharacters],page];
    
    [[DWRequestManager sharedDWRequestManager] createAppRequest:localURL
                                            successNotification:kNProductsLoaded
                                              errorNotification:kNProductsLoadError
                                                  requestMethod:kGet
                                                   authenticate:YES 
                                                     resourceID:page+1];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)productsLoaded:(NSNotification*)notification {

    SEL sel = @selector(productsLoaded:withQueries:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    NSDictionary *info          = [notification userInfo];
    NSDictionary *response      = [info objectForKey:kKeyResponse];
    NSNumber *resourceID        = [info objectForKey:kKeyResourceID];
        
    NSString *query             = [response objectForKey:kKeyQuery];
    NSString *saneQuery         = [response objectForKey:kKeySaneQuery];
    NSArray *productsResponse   = [response objectForKey:kKeyProducts];
    
    NSInteger count             = [resourceID integerValue] * kMaxProductsPerPage;
    NSMutableArray *products    = [NSMutableArray arrayWithCapacity:[productsResponse count]];
    
    
    for(NSDictionary *product in productsResponse) {
        [products addObject:[DWProduct create:product 
                                 withObjectID:[NSString stringWithFormat:@"%d",++count]]];
    }
    
    [self.delegate performSelector:sel
                        withObject:products 
                        withObject:[NSArray arrayWithObjects:query,saneQuery,nil]];
}

//----------------------------------------------------------------------------------------------------
- (void)productsLoadError:(NSNotification*)notification {
    
    SEL sel = @selector(productsLoadError:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    
    NSDictionary *info      = [notification userInfo];
    NSError *error          = [info objectForKey:kKeyError];
    
    [self.delegate performSelector:sel
                        withObject:[error localizedDescription]];
}

@end

