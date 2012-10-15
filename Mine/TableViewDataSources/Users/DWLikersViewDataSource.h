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
    BOOL _loadRemotely;
}


@property (nonatomic,assign) NSInteger purchaseID;
@property (nonatomic,assign) BOOL loadRemotely;

@end
