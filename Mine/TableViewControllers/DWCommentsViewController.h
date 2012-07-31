//
//  DWCommentsViewController.h
//  Mine
//
//  Created by Siddharth Batra on 7/30/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWTableViewController.h"

@interface DWCommentsViewController : DWTableViewController


/**
 * Init with comments to be displayed.
 */ 
- (id)initWithComments:(NSMutableArray*)comments;

@end
