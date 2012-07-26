//
//  DWProfileViewController.h
//  Mine
//
//  Created by Siddharth Batra on 7/26/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWTableViewController.h"

@class DWUser;

@interface DWProfileViewController : DWTableViewController {
    DWUser  *_user;
}

/**
 * The user whose profile is being displayed.
 */
@property (nonatomic,strong) DWUser *user;


/**
 * Init with the user whose profile is to be displayed.
 */ 
- (id)initWithUser:(DWUser*)user;

@end
