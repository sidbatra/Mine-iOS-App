//
//  DWFollowersViewDataSource.h
//  Mine
//
//  Created by Siddharth Batra on 8/2/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWUsersViewDataSource.h"

@interface DWFollowersViewDataSource : DWUsersViewDataSource {
    NSInteger   _userID;
}

/**
 * ID of the user whose followers are being displayed.
 */
@property (nonatomic,assign) NSInteger userID;

@end
