//
//  DWPagination.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Pagination model used to inject a pagination cell into table views
 */
@interface DWPagination : NSObject {
    BOOL    _isTriggered;
    BOOL    _isDisabled;
    
    __weak id _owner;
}

/**
 * Indicates if pagination has been triggered
 */
@property (nonatomic,assign) BOOL isTriggered;

/**
 * Indicates if pagination has been disabled
 */
@property (nonatomic,assign) BOOL isDisabled;

/**
 * Owner of the pagination cell
 */
@property (nonatomic,weak) id owner;

@end
