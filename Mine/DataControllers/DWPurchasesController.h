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

/**
 * Fetch purchases for a user before the given time
 */
- (void)getPurchasesForUser:(NSInteger)userID 
                     before:(NSInteger)before;

/**
 * Create a new purchase.
 */
- (NSInteger)createPurchaseFromTemplate:(DWPurchase*)purchase
                             andProduct:(DWProduct*)product
                          withShareToFB:(BOOL)shareToFB
                          withShareToTW:(BOOL)shareToTW
                          withShareToTB:(BOOL)shareToTB 
                         uploadDelegate:(id)uploadDelegate;
@end


/**
 * Protocol for the DWPurchasesController delegate. Fires 
 * messages about the success and failure of requests
 */
@protocol DWPurchasesControllerDelegate

@optional

/**
 * A user's purchases are loaded successfully.
 */
- (void)purchasesLoaded:(NSMutableArray*)purchases 
                forUser:(NSNumber*)userID;

/**
 * Error loading purchases.
 */
- (void)purchasesLoadError:(NSString*)error 
                   forUser:(NSNumber*)userID;

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


@end