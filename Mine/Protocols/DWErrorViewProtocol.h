//
//  DWTableErrorViewProtocol.h
//  Mine
//
//  Created by Siddharth Batra on 7/24/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//
#import <Foundation/Foundation.h>

/**
 * Default protocol for displaying an error view.
 */
@protocol DWErrorViewProtocol

@required

/**
 * Apply a custom error message
 */
- (void)setErrorMessage:(NSString*)message;

/**
 * Hide the view and the refresh UI if any.
 */
- (void)hide;

/**
 * Display the view with an option for displaying a refresh UI
 */
- (void)showWithRefreshUI:(BOOL)showRefreshUI;

@end