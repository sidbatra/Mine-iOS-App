//
//  DWProfileViewDataSource.m
//  Mine
//
//  Created by Siddharth Batra on 7/26/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWProfileViewDataSource.h"
 
@interface DWProfileViewDataSource() {
    DWPurchasesController *_purchasesController;
    
    NSInteger _oldestTimestamp;
}

/**
 * Data controller for fetching purchases.
 */
@property (nonatomic,strong) DWPurchasesController* purchasesController;

/**
 * Timestamp of the last item in the feed. Used to fetch more items.
 */
@property (nonatomic,assign) NSInteger oldestTimestamp;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWProfileViewDataSource

@synthesize userID                  = _userID;
@synthesize purchasesController     = _purchasesController;
@synthesize oldestTimestamp         = _oldestTimestamp;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.purchasesController            = [[DWPurchasesController alloc] init];
        self.purchasesController.delegate   = self;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)loadPurchases {
    [self.purchasesController getPurchasesForUser:self.userID 
                                           before:self.oldestTimestamp];
}

//----------------------------------------------------------------------------------------------------
- (void)refreshInitiated {
    [self.purchasesController getPurchasesForUser:self.userID 
                                           before:0];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWPurchasesControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)purchasesLoaded:(NSMutableArray *)purchases 
                forUser:(NSNumber*)userID {
    
    if(self.userID != [userID integerValue])
        return;
    
    self.objects = purchases;
    
    [self.delegate reloadTableView];
}

//----------------------------------------------------------------------------------------------------
- (void)purchasesLoadError:(NSString *)error 
                   forUser:(NSNumber*)userID {

    if(self.userID != [userID integerValue])
        return;
    
    [self.delegate displayError:error
                  withRefreshUI:YES];
}


@end
