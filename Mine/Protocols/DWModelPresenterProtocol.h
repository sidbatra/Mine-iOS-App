//
//  DWModelPresenter.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Required protocol for all model presenters
 */
@protocol DWModelPresenterProtocol

@required

/**
 * Setup the cell for being displayed in a table view. Optionally
 * allocate memory if the base cell is nil
 */
+ (UITableViewCell*)cellForObject:(id)object
                     withBaseCell:(id)base
               withCellIdentifier:(NSString*)identifier
                     withDelegate:(id)delegate
             andPresentationStyle:(NSInteger)style;

/**
 * Compute the height for the given object
 */
+ (CGFloat)heightForObject:(id)object 
     withPresentationStyle:(NSInteger)style;

/**
 * Update the cell when a new resource is made available
 */
+ (void)updatePresentationForCell:(id)base
                         ofObject:(id)object
            withPresentationStyle:(NSInteger)style
                  withObjectClass:(Class)objectClass
                     withObjectID:(NSInteger)objectID
                     andObjectKey:(NSString*)objectKey;

/**
 * Send messages to the delegate when the cell is clicked for the
 * given object
 */
+ (void)cellClickedForObject:(id)object
                withBaseCell:(id)base
       withPresentationStyle:(NSInteger)style
                withDelegate:(id)delegate;

@end
