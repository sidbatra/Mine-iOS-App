//
//  DWLikesController.h
//  Mine
//
//  Created by Siddharth Batra on 7/30/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DWLike;
@protocol DWLikesControllerDelegate;


@interface DWLikesController : NSObject {
    __weak id<DWLikesControllerDelegate,NSObject> _delegate;
}


/**
 * Delegate for theDWLikesControllerDelegate protocol
 */
@property (nonatomic,weak) id<DWLikesControllerDelegate,NSObject> delegate;


/**
 * Create like on the given purchase ID
 */
- (void)createLikeForPurchaseID:(NSInteger)purchaseID;

@end


/**
 * Protocol for the DWLikesController delegate. Fires 
 * messages about the success and failure of requests
 */
@protocol DWLikesControllerDelegate

@required

/**
 * Like successfully created
 */
- (void)likeCreated:(DWLike*)like 
      forPurchaseID:(NSNumber*)purchaseID;

/**
 * Error creating like.
 */
- (void)likeCreateError:(NSString*)error 
          forPurchaseID:(NSNumber*)purchaseID;

@end