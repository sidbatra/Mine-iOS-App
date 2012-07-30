//
//  DWDoubleLineCell.h
//  Mine
//
//  Created by Deepak Rao on 7/27/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Forms the background view of a selected double line cell
 */
@interface DWDoubleLineSelectedView : UIView {
}

@end


/**
 * Forms the background view of a double line cell
 */
@interface DWDoubleLineView : UIView {
	NSString	*_firstLine;
	NSString	*_secondLine;
	
	BOOL		_highlighted;
    BOOL        _isDarker;
}


/**
 * First line
 */
@property (nonatomic,copy) NSString* firstLine;

/**
 * Second line
 */
@property (nonatomic,copy) NSString* secondLine;

/**
 * Checks if the cell is in its darker state
 */
@property (nonatomic,assign) BOOL isDarker;

/**
 * Reset any variables that may not be refreshed - eg : _highlight
 */
- (void)reset;

/**
 * Set the view to redraw when visible content has
 * been modified
 */
- (void)redisplay;

@end


/**
 * Cell for displaying place search results
 */
@interface DWDoubleLineCell : UITableViewCell {
	DWDoubleLineView *_doubleLineView;
}

/**
 * Primary view for drawing content
 */
@property (nonatomic,strong) DWDoubleLineView *doubleLineView;


/**
 * Reset any variables that may not be refreshed 
 */
- (void)reset;

/**
 * Set the text for first line
 */
- (void)setFirstLine:(NSString*)firstLine;

/**
 * Set the text for second line
 */ 
- (void)setSecondLine:(NSString*)secondLine;

/**
 * Turn on the dark colored state
 */ 
- (void)turnOnDarkerState;

/**
 * Sets the cell to be rerendered
 */
- (void)redisplay;

@end
