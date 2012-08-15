//
//  DWSuggestionsViewController.h
//  Mine
//
//  Created by Deepak Rao on 8/15/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DWSuggestionsController.h"

@protocol DWSuggestionsViewControllerDelegate;

/**
 * Displays suggestions for creation
 */
@interface DWSuggestionsViewController : UIViewController<DWSuggestionsControllerDelegate> {    
    __weak id<DWSuggestionsViewControllerDelegate> _delegate;
}

/**
 * Delegate following the DWSuggestionsViewControllerDelegate protocol.
 */
@property (nonatomic,weak) id<DWSuggestionsViewControllerDelegate> delegate;

@end


/**
 * Protocol for DWSuggestionsViewController delegates.
 */
@protocol DWSuggestionsViewControllerDelegate

@optional

/**
 * User picks a suggestion.
 */
- (void)suggestionPicked:(NSInteger)suggestionID;

@end