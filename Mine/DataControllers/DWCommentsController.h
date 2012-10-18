//
//  DWCommentsController.h
//  Mine
//
//  Created by Siddharth Batra on 7/31/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DWComment;
@protocol DWCommentsControllerDelegate;


@interface DWCommentsController : NSObject {
    __weak id<DWCommentsControllerDelegate,NSObject> _delegate;
}

/**
 * Delegate following the DWCommentsControllerDelegate protocol.
 */
@property (nonatomic,weak) id<DWCommentsControllerDelegate,NSObject> delegate;


- (void)getCommentsForPurchaseID:(NSInteger)purchaseID;

/**
 * Create a new comment.
 */
- (void)createCommentForPurchaseID:(NSInteger)purchaseID 
                       withMessage:(NSString*)message;

@end



/**
 * Protocol for the DWCommentsController delegate. Fires 
 * messages about the success and failure of requests
 */
@protocol DWCommentsControllerDelegate

@optional

- (void)commentsLoaded:(NSMutableArray*)comments
         forPurchaseID:(NSNumber*)purchaseID;

- (void)commentsLoadError:(NSString*)error
            forPurchaseID:(NSNumber*)purchaseID;

/**
 * Comment successfully created
 */
- (void)commentCreated:(DWComment*)comment 
         forPurchaseID:(NSNumber*)purchaseID;

/**
 * Error creating comment.
 */
- (void)commentCreateError:(NSString*)error 
             forPurchaseID:(NSNumber*)purchaseID;

@end