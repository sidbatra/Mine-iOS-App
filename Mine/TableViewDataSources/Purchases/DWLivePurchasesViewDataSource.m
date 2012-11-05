//
//  DWLivePurchasesViewDataSource.m
//  Mine
//
//  Created by Siddharth Batra on 11/2/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWLivePurchasesViewDataSource.h"

static NSInteger const kInitialRetryInterval = 10;
static NSInteger const kDefaultRetryInterval = 3;
static CGFloat const kRetryDelta = 1.5;
static NSInteger const kMaxTries = 3;


@interface DWLivePurchasesViewDataSource() {
    BOOL _isInitialTry;
    
    NSInteger _offset;
    CGFloat   _retryInterval;
    NSInteger _tries;
}

@property (nonatomic,assign) BOOL isInitialTry;
@property (nonatomic,assign) NSInteger offset;
@property (nonatomic,assign) CGFloat retryInterval;
@property (nonatomic,assign) NSInteger tries;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWLivePurchasesViewDataSource

@synthesize offset = _offset;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.isInitialTry = YES;
        self.retryInterval = kDefaultRetryInterval;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)loadDelayedPurchases {
    [self.purchasesController getUnapprovedLivePurchasesAtOffset:self.offset
                                                         perPage:10];
}

//----------------------------------------------------------------------------------------------------
- (void)loadPurchases {
        
    [self performSelector:@selector(loadDelayedPurchases)
               withObject:nil
               afterDelay:self.isInitialTry ? kInitialRetryInterval : self.retryInterval];
    
    self.isInitialTry = NO;
}

//----------------------------------------------------------------------------------------------------
- (void)refreshInitiated {
    self.isInitialTry = YES;
    self.offset = 0;
    self.tries = 0;
    self.retryInterval = kInitialRetryInterval;
    
    [super refreshInitiated];
}

//----------------------------------------------------------------------------------------------------
- (void)paginate {
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWPurchasesControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)unapprovedPurchasesLoaded:(NSMutableArray *)purchases {
    
    if([purchases count]) {
        [super unapprovedPurchasesLoaded:purchases];
        
        self.tries = 0;
        self.offset += [purchases count];
        self.retryInterval = kDefaultRetryInterval;
        
        [self loadPurchases];
    }
    else if(self.tries++ < kMaxTries ) {
        self.retryInterval *= kRetryDelta;
        
        [self loadPurchases];
    }
    else {
        [super unapprovedPurchasesLoaded:purchases];
        
        self.arePurchasesFinished = YES;
        [self.delegate unapprovedPurchasesFinished:self.selectedIDs.count+self.rejectedIDs.count];
    }
}

@end