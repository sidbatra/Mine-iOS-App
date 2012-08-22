//
//  DWSearchBar.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol DWSearchBarDelegate;

/**
 * Custom search bar - UITextField with a cancel button
 */
@interface DWSearchBar : UIView<UITextFieldDelegate> {
    UITextField     *searchTextField;
    
    NSInteger       _minimumQueryLength;
    
    id<DWSearchBarDelegate> __unsafe_unretained _delegate;
}

/**
 * Search success delegate isn't fired until these many chars are entered
 */
@property (nonatomic,assign) NSInteger minimumQueryLength;

/**
 * Delegate property
 */
@property (nonatomic,unsafe_unretained) id<DWSearchBarDelegate> delegate;


/**
 * Take the search bar into an active state
 */
- (void)becomeActive;

/**
 * Widthdraw the search bar from an active state
 */
- (void)resignActive;

/**
 * Hide the keyboard
 */
- (void)hideKeyboard;

@end


/**
 * Protocol for the delegates of DWSearchBar instances
 */
@protocol DWSearchBarDelegate

/**
 * Fired when a search is initiated
 */
- (void)searchWithQuery:(NSString*)query;

/**
 * Fired when searching is cancelled
 */
- (void)searchCancelled;

@end
