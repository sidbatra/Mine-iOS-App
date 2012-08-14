//
//  DWSuggestionsController.h
//  Mine
//
//  Created by Deepak Rao on 8/14/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol DWSuggestionsControllerDelegate;


@interface DWSuggestionsController : NSObject {
    __weak id<DWSuggestionsControllerDelegate,NSObject> _delegate;
}


/**
 * Delegate for the DWSuggestionsControllerDelegate protocol
 */
@property (nonatomic,weak) id<DWSuggestionsControllerDelegate,NSObject> delegate;


/**
 * Fetch suggestions for the current user
 */
- (void)getSuggestions;

@end


/**
 * Protocol for the DWSuggestionsController delegate. Fires 
 * messages about the success and failure of requests
 */
@protocol DWSuggestionsControllerDelegate

@optional

/**
 * Suggestions are loaded successfully.
 */
- (void)suggestionsLoaded:(NSMutableArray*)suggestions;

/**
 * Error loading suggestions.
 */
- (void)suggestionsLoadError:(NSString*)error;


@end