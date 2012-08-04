//
//  DWPurchasesViewController.m
//  Mine
//
//  Created by Siddharth Batra on 8/4/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWPurchasesViewController.h"


#import "DWPurchaseFeedPresenter.h"
#import "DWPaginationPresenter.h"

#import "DWPurchase.h"
#import "DWUser.h"
#import "DWLike.h"

#import "DWSession.h"
#import "DWConstants.h"



@interface DWPurchasesViewController ()

/**
 * Reload row that belongs to the given purchase.
 */
- (void)reloadRowForPurchase:(DWPurchase*)purchase;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWPurchasesViewController

@synthesize likesController = _likesController;
@synthesize delegate        = _delegate;


//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {        
        
        self.likesController = [[DWLikesController alloc] init];
        self.likesController.delegate = self;
                
        
        [self addModelPresenterForClass:[DWPurchase class]
                              withStyle:kDefaultModelPresenter 
                          withPresenter:[DWPurchaseFeedPresenter class]];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(purchaseGiantImageLoaded:) 
                                                     name:kNImgPurchaseGiantLoaded
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(userSquareImageLoaded:) 
                                                     name:kNImgUserSquareLoaded
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(commentAddedForPurchase:) 
                                                     name:kNCommentAddedForPurchase
                                                   object:nil];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//----------------------------------------------------------------------------------------------------
- (void)reloadRowForPurchase:(DWPurchase*)purchase {
    NSInteger index = [self.tableViewDataSource indexForObject:purchase];
    
    if(index == NSNotFound)
        return;
    
    [self reloadRowAtIndex:index];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)purchaseGiantImageLoaded:(NSNotification*)notification {
    NSDictionary *userInfo = [notification userInfo];
    
    [self provideResourceToVisibleCells:[DWPurchase class] 
                               objectID:[[userInfo objectForKey:kKeyResourceID] integerValue]
                              objectKey:kKeyGiantImageURL];
}

//----------------------------------------------------------------------------------------------------
- (void)userSquareImageLoaded:(NSNotification*)notification {
    NSDictionary *userInfo = [notification userInfo];
    
    [self provideResourceToVisibleCells:[DWUser class] 
                               objectID:[[userInfo objectForKey:kKeyResourceID] integerValue]
                              objectKey:kKeySquareImageURL];
}

//----------------------------------------------------------------------------------------------------
- (void)commentAddedForPurchase:(NSNotification*)notification {
    NSDictionary *userInfo = [notification userInfo];
    
    [self reloadRowForPurchase:(DWPurchase*)[userInfo objectForKey:kKeyPurchase]];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWLikesControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)likeCreated:(DWLike *)like 
      forPurchaseID:(NSNumber *)purchaseID {
    
    DWPurchase *purchase = [DWPurchase fetch:[purchaseID integerValue]];
    
    if(!purchase)
        return;
    
    [purchase replaceTempLikeWithMountedLike:like];
}

//----------------------------------------------------------------------------------------------------
- (void)likeCreateError:(NSString *)error 
          forPurchaseID:(NSNumber *)purchaseID {
    
    DWPurchase *purchase = [DWPurchase fetch:[purchaseID integerValue]];
    
    if(!purchase)
        return;
    
    [purchase removeTempLike];
    
    
    [self reloadRowForPurchase:purchase];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWPurchaseFeedCellDelegate

//----------------------------------------------------------------------------------------------------
- (void)userClicked:(NSNumber *)userID {
    
    SEL sel = @selector(purchasesViewUserClicked:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    DWUser *user = [DWUser fetch:[userID integerValue]];
    
    if(user)
        [self.delegate performSelector:sel 
                            withObject:user];
}

//----------------------------------------------------------------------------------------------------
- (void)likeClickedForPurchaseID:(NSNumber *)purchaseID {
    DWPurchase *purchase = [DWPurchase fetch:[purchaseID integerValue]];
    
    if(!purchase)
        return;
    
    [purchase addTempLikeByUser:[DWSession sharedDWSession].currentUser];
    
    [self reloadRowForPurchase:purchase];
    
    [self.likesController createLikeForPurchaseID:purchase.databaseID];
}

//----------------------------------------------------------------------------------------------------
- (void)allLikesClickedForPurchaseID:(NSNumber *)purchaseID {
    
    SEL sel = @selector(purchasesViewAllLikesClickedForPurchase:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    DWPurchase *purchase = [DWPurchase fetch:[purchaseID integerValue]];
    
    if(!purchase)
        return;
    
    [self.delegate performSelector:sel
                        withObject:purchase];
}

//----------------------------------------------------------------------------------------------------
- (void)commentClickedForPurchaseID:(NSNumber *)purchaseID 
                 withCreationIntent:(NSNumber *)creationIntent {
    
    SEL sel = @selector(purchasesViewCommentClickedForPurchase:withCreationIntent:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    DWPurchase *purchase = [DWPurchase fetch:[purchaseID integerValue]];
    
    if(!purchase)
        return;
    
    [self.delegate performSelector:sel
                        withObject:purchase
                        withObject:creationIntent];
}

@end
