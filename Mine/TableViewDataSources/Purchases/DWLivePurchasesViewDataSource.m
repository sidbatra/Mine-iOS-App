//
//  DWLivePurchasesViewDataSource.m
//  Mine
//
//  Created by Siddharth Batra on 11/2/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWLivePurchasesViewDataSource.h"
#import "DWStore.h"
#import "DWSession.h"
#import "DWPurchase.h"
#import "DWConstants.h"

#import "SBJsonParser.h"

static NSInteger const kInitialPurchasesRetryInterval = 5;
static NSInteger const kInitialUserRetryInterval = 3;
static NSInteger const kPurchasesRetryInterval = 3;
static NSInteger const kUserRetryInterval = 1.5;


@interface DWLivePurchasesViewDataSource() {
    DWUsersController   *_usersController;
    
    BOOL _isInitialTry;
    BOOL _purchasesLoading;
    BOOL _waitingForPurchases;
    
    NSInteger _offset;
}

@property (nonatomic,strong) DWUsersController *usersController;
@property (nonatomic,assign) BOOL isInitialTry;
@property (nonatomic,assign) BOOL purchasesLoading;
@property (nonatomic,assign) BOOL waitingForPurchases;
@property (nonatomic,assign) NSInteger offset;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWLivePurchasesViewDataSource

@synthesize usersController = _usersController;
@synthesize offset = _offset;
@synthesize isInitialTry = _isInitialTry;
@synthesize purchasesLoading = _purchasesLoading;
@synthesize waitingForPurchases = _waitingForPurchases;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.isInitialTry = YES;
        
        self.usersController = [[DWUsersController alloc] init];
        self.usersController.delegate = self;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)loadDelayedPurchases {
    [self.purchasesController getUnapprovedLivePurchasesAtOffset:self.offset
                                                         perPage:100];
}

//----------------------------------------------------------------------------------------------------
- (void)loadPurchases {
    if(self.arePurchasesFinished)
        return;
    
    if(self.isInitialTry) {
        [self.purchasesController getUnapprovedPurchasesMiningStarted];
        
        self.isInitialTry = NO;
    }
    else {
        self.purchasesLoading = YES;

        [self performSelector:@selector(loadDelayedPurchases)
                   withObject:nil
                   afterDelay:kPurchasesRetryInterval];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)loadDelayedUser {
    [self.usersController getUserWithID:[DWSession sharedDWSession].currentUser.databaseID];
}

//----------------------------------------------------------------------------------------------------
- (void)loadUser {
    [self performSelector:@selector(loadDelayedUser)
               withObject:nil
               afterDelay:kUserRetryInterval];
}

//----------------------------------------------------------------------------------------------------
- (void)refreshInitiated {
    self.isInitialTry = YES;
    self.arePurchasesFinished = NO;
    self.offset = 0;
    
    [super refreshInitiated];
}

//----------------------------------------------------------------------------------------------------
- (void)paginate {
}

//----------------------------------------------------------------------------------------------------
- (void)finishProcessing {
    [self.delegate unapprovedPurchasesStatus:nil
                                    progress:1.0];
    
    [super unapprovedPurchasesLoaded:[NSArray array]];
    
    self.usersController = nil;
    self.arePurchasesFinished = YES;
    [self.delegate unapprovedPurchasesFinished:self.selectedIDs.count+self.rejectedIDs.count];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWUsersControllerDelegate 

//----------------------------------------------------------------------------------------------------
- (void)userLoaded:(DWUser *)user
        withUserID:(NSNumber *)userID {
    
    if([DWSession sharedDWSession].currentUser.databaseID != [userID integerValue])
        return;
    
    if(user.isMiningPurchases) {
        
        if(user.emailMiningMetadata) {
            SBJsonParser* parser = [[SBJsonParser alloc] init];
            NSDictionary* metadata = [parser objectWithString:user.emailMiningMetadata];
            
            if(metadata) {
                CGFloat progress = [[metadata objectForKey:kKeyProgress] floatValue];
                DWStore *store = [DWStore create:[metadata objectForKey:kKeyStore]];
                
                [self.delegate unapprovedPurchasesStatus:store
                                                progress:progress];
            }
                
        }
        
        [self loadUser];
    }
    else {
        if(self.purchasesLoading)
            self.waitingForPurchases = YES;
        else
            [self finishProcessing];
    }
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWPurchasesControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)unapprovedPurchasesMiningStarted {
    [self performSelector:@selector(loadDelayedPurchases)
               withObject:nil
               afterDelay:kInitialPurchasesRetryInterval];
    
    [self performSelector:@selector(loadDelayedUser)
               withObject:nil
               afterDelay:kInitialUserRetryInterval];
}

//----------------------------------------------------------------------------------------------------
- (void)unapprovedPurchasesMiningStartError:(NSString *)error {
    [self.delegate displayError:error
                  withRefreshUI:YES];
}

//----------------------------------------------------------------------------------------------------
- (void)unapprovedPurchasesLoaded:(NSMutableArray *)purchases {
    
    self.purchasesLoading = NO;
    
    if([purchases count]) {
        [super unapprovedPurchasesLoaded:purchases];
        
        self.offset += [purchases count];
    }
    
    if(self.waitingForPurchases)
        [self finishProcessing];
    else
        [self loadPurchases];
}

@end
