//
//  DWFollowersViewController.h
//  Mine
//
//  Created by Siddharth Batra on 8/2/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWUsersViewController.h"

@class DWUser;

@interface DWFollowersViewController : DWUsersViewController

/**
 * Init with the user whose followers are being displayed.
 */
- (id)initWithUser:(DWUser*)user;

@end
