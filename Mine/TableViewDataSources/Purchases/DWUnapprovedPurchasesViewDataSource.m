//
//  DWUnapprovedPurchasesViewDataSource.m
//  Mine
//
//  Created by Siddharth Batra on 11/2/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWUnapprovedPurchasesViewDataSource.h"
#import "DWPurchase.h"
#import "DWModelSet.h"
#import "DWPagination.h"
#import "DWConstants.h"

@interface DWUnapprovedPurchasesViewDataSource()
@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUnapprovedPurchasesViewDataSource

@synthesize purchasesController = _purchasesController;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.purchasesController = [[DWPurchasesController alloc] init];
        self.purchasesController.delegate = self;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)loadPurchases {
}

//----------------------------------------------------------------------------------------------------
- (void)refreshInitiated {    
    id lastObject   = [self.objects lastObject];
    
    if([lastObject isKindOfClass:[DWPagination class]]) {
        ((DWPagination*)lastObject).isDisabled = YES;
    }
    
    [self loadPurchases];
}

//----------------------------------------------------------------------------------------------------
- (void)paginate {
}

//----------------------------------------------------------------------------------------------------
- (void)addObjectsFromPurchases:(NSMutableArray*)purchases
              withStartingIndex:(NSInteger)startingIndex {
    
    NSInteger count = [purchases count];
    
    for(NSInteger i=startingIndex ; i < count ; i+=kColumnsInUnapprovedPurchases) {
        DWModelSet *purchaseSet = [[DWModelSet alloc] init];
        
        for (NSInteger j=0; j<kColumnsInUnapprovedPurchases; j++) {
            NSInteger index = i+j;
            
            if(index < count)
                [purchaseSet addModel:[purchases objectAtIndex:index]];
        }
        
        [self.objects addObject:purchaseSet];
    }
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWPurchasesControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)unapprovedPurchasesLoaded:(NSMutableArray *)purchases {
    
    id lastObject               = [self.objects lastObject];
    BOOL paginate               = NO;
    NSInteger startingIndex     = 0;
    
    
    if([lastObject isKindOfClass:[DWPagination class]]) {
        paginate = !((DWPagination*)lastObject).isDisabled;
    }
    
    if(!paginate) {
        [self clean];
        self.objects = [NSMutableArray array];
    }
    else {
        [self.objects removeLastObject];
        
        DWModelSet *lastSet = [self.objects lastObject];
        startingIndex = kColumnsInUnapprovedPurchases - lastSet.length;
        
        if(startingIndex != 0 && [purchases count]) {
            for(NSInteger i=0 ; i < startingIndex ; i++) {
                [lastSet addModel:[purchases objectAtIndex:i]];
            }
        }
    }
    
    [self addObjectsFromPurchases:purchases
                withStartingIndex:startingIndex];
    
    
    if([purchases count]) {        
        DWPagination *pagination    = [[DWPagination alloc] init];
        pagination.owner            = self;
        [self.objects addObject:pagination];
        
        [self loadPurchases];
    }
    
    
    [self.delegate reloadTableView];
}

//----------------------------------------------------------------------------------------------------
- (void)unapprovedPurchasesLoadError:(NSString *)error {
    [self.delegate displayError:error
                  withRefreshUI:YES];
}

@end
