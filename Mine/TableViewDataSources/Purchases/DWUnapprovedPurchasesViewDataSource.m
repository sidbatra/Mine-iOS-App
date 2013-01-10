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

@interface DWUnapprovedPurchasesViewDataSource() {
    NSMutableArray *_rejectedIDs;
}

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUnapprovedPurchasesViewDataSource

@synthesize purchasesController = _purchasesController;
@synthesize arePurchasesFinished = _arePurchasesFinished;
@synthesize rejectedIDs = _rejectedIDs;

@synthesize delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.purchasesController = [[DWPurchasesController alloc] init];
        self.purchasesController.delegate = self;
        
        self.rejectedIDs = [NSMutableArray array];
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
- (void)removePurchase:(NSInteger)purchaseID {
    
    [self.rejectedIDs addObject:[NSNumber numberWithInteger:purchaseID]];
    
    
    NSMutableArray *purchases = [NSMutableArray array];
    
    for(id object in self.objects) {
        if([object isKindOfClass:[DWModelSet class]]) {
            for(DWPurchase* purchase in [(DWModelSet*)object models]) {
                
                if ([purchase databaseID] != purchaseID)
                    [purchases addObject:purchase];
            }
        }
    }
    
    self.objects = nil;
    [self populatePurchases:purchases];
}

//---------------------------------------------------------------------------------------------------
- (void)populatePurchases:(NSMutableArray*)purchases {
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
    
    
    if([purchases count] && !self.arePurchasesFinished) {
        DWPagination *pagination    = [[DWPagination alloc] init];
        pagination.owner            = self;
        [self.objects addObject:pagination];
    }
    
    
    [self.delegate reloadTableView];
}

//----------------------------------------------------------------------------------------------------
- (NSMutableArray*)selectedIDs {
    
    NSMutableArray *ids = [NSMutableArray array];
    
    for(id object in self.objects) {
        if([object isKindOfClass:[DWModelSet class]]) {
            for(DWPurchase* purchase in [(DWModelSet*)object models]) {
                [ids addObject:[NSNumber numberWithInteger:purchase.databaseID]];
            }
        }
    }
    
    return ids;
}

//----------------------------------------------------------------------------------------------------
- (NSInteger)totalPurchases {
    return self.selectedIDs.count + self.rejectedIDs.count;
}

//----------------------------------------------------------------------------------------------------
- (void)approveSelectedPurchases {
    [self.purchasesController approveMultiplePurchases:self.selectedIDs
                                           rejectedIDs:self.rejectedIDs];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWPurchasesControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)multiplePurchasesUpdated {
    [self.delegate unapprovedPurchasesApprovedWithCount:self.selectedIDs.count];
}

//----------------------------------------------------------------------------------------------------
- (void)multiplePurchasesUpdateError:(NSString *)error {
    [self.delegate unapprovedPurchasesApproveError];
}

//----------------------------------------------------------------------------------------------------
- (void)unapprovedPurchasesLoaded:(NSMutableArray *)purchases {
    [self populatePurchases:purchases];
}

//----------------------------------------------------------------------------------------------------
- (void)unapprovedPurchasesLoadError:(NSString *)error {
    [self.delegate displayError:error
                  withRefreshUI:YES];
}

@end
