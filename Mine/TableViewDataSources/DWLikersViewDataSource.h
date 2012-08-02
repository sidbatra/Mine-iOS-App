//
//  DWLikersViewDataSource.h
//  Mine
//
//  Created by Siddharth Batra on 8/2/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWUsersViewDataSource.h"

@interface DWLikersViewDataSource : DWUsersViewDataSource {
    NSInteger _purchaseID;
}

/**
 * Purchase id for which the likers are being displayed.
 */
@property (nonatomic,assign) NSInteger purchaseID;

@end
