//
//  DWPurchasesController.h
//  Mine
//
//  Created by Siddharth Batra on 7/26/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DWPurchase;
@class DWProduct;
@protocol DWPurchasesControllerDelegate;

@interface DWPurchasesController : NSObject {
    __weak id<DWPurchasesControllerDelegate,NSObject> _delegate;
}

/**
 * Delegate for the DWPurchasesControllerDelegate protocol
 */
@property (nonatomic,weak) id<DWPurchasesControllerDelegate,NSObject> delegate;


- (void)getPurchase:(NSInteger)purchaseID;

/**
 * Fetch purchases for a user before the given time
 */
- (void)getPurchasesForUser:(NSInteger)userID 
                     before:(NSInteger)before
                 withCaller:(NSObject*)caller;


- (void)getUnapprovedStalePurchasesBefore:(NSInteger)before
                                  perPage:(NSInteger)perPage;


- (void)getUnapprovedLivePurchasesAtOffset:(NSInteger)offset
                                   perPage:(NSInteger)perPage;

/**
 * Create a new purchase.
 */
- (NSInteger)createPurchaseFromTemplate:(DWPurchase*)purchase
                             andProduct:(DWProduct*)product
                          withShareToFB:(BOOL)shareToFB
                          withShareToTW:(BOOL)shareToTW
                          withShareToTB:(BOOL)shareToTB 
                         uploadDelegate:(id)uploadDelegate;

- (void)approveMultiplePurchases:(NSMutableArray*)selectedIDs
                     rejectedIDs:(NSMutableArray*)rejectedIDs;

/** 
 * Delete a purchase
 */
- (void)deletePurchaseWithID:(NSInteger)purchaseID;

@end


/**
 * Protocol for the DWPurchasesController delegate. Fires 
 * messages about the success and failure of requests
 */
@protocol DWPurchasesControllerDelegate

@optional

/**
 * A purchase is loaded successfully.
 */
- (void)purchaseLoaded:(DWPurchase*)purchase
        withResourceID:(NSNumber*)resourceID;

/**
 * Error loading a purchase.
 */
- (void)purchaseLoadError:(NSString*)message
           withResourceID:(NSNumber*)resourceID;

/**
 * A user's purchases are loaded successfully.
 */
- (void)purchasesLoaded:(NSMutableArray*)purchases;

/**
 * Error loading purchases.
 */
- (void)purchasesLoadError:(NSString*)error;


- (void)unapprovedPurchasesLoaded:(NSMutableArray*)purchases;

- (void)unapprovedPurchasesLoadError:(NSString*)error;

/**
 * Purchase successfully created.
 */
- (void)purchaseCreated:(DWPurchase*)purchase
         fromResourceID:(NSNumber*)resourceID;

/**
 * Purchase creation error.
 */
- (void)purchaseCreateError:(NSString*)error
             fromResourceID:(NSNumber*)resourceID;

- (void)multiplePurchasesUpdated;

- (void)multiplePurchasesUpdateError:(NSString*)error;

/**
 * Purchase successfully deleted.
 */
- (void)purchaseDeleted:(NSNumber*)purchaseID;

/**
 * Purchase deletion error.
 */
- (void)purchaseDeleteError:(NSString*)error
             fromResourceID:(NSNumber*)resourceID;


@end