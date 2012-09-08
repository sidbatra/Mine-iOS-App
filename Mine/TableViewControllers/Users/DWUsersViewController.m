//
//  DWUsersViewController.m
//  Mine
//
//  Created by Siddharth Batra on 8/2/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWUsersViewController.h"

#import "DWUsersViewDataSource.h"
#import "DWuserPresenter.h"
#import "DWNavigationBarBackButton.h"
#import "DWUser.h"

#import "DWConstants.h"


@interface DWUsersViewController ()
@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUsersViewController

@synthesize delegate            = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {        
        
        [self addModelPresenterForClass:[DWUser class]
                              withStyle:kDefaultModelPresenter 
                          withPresenter:[DWUserPresenter class]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(userSquareImageLoaded:) 
                                                     name:kNImgUserSquareLoaded
                                                   object:nil];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [DWNavigationBarBackButton backButtonForNavigationController:self.navigationController];
    
    [(DWUsersViewDataSource*)self.tableViewDataSource loadUsers];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWUserCellDelegate

//----------------------------------------------------------------------------------------------------
- (void)userCellFollowClickedForUserID:(NSInteger)userID {
    [(DWUsersViewDataSource*)self.tableViewDataSource toggleFollowForUserID:userID];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWUserViewDataSourceDelegate

//----------------------------------------------------------------------------------------------------
- (void)followingModifiedForUserID:(NSInteger)userID toStatus:(BOOL)isActive {
    [self provideResourceToVisibleCells:[DWUser class] 
                               objectID:userID
                              objectKey:isActive ? kKeyFollowingCreated : kKeyFollowingDestroyed];
}

//----------------------------------------------------------------------------------------------------
- (void)followingsLoaded {
    [self provideResourceToVisibleCells:[DWUser class] 
                               objectID:-1
                              objectKey:kKeyFollowing];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark User presenter events

//----------------------------------------------------------------------------------------------------
- (void)userPresenterUserSelected:(DWUser*)user {
    [self.delegate usersViewUserClicked:user];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)userSquareImageLoaded:(NSNotification*)notification {
    NSDictionary *userInfo = [notification userInfo];

    [self provideResourceToVisibleCells:[DWUser class] 
                               objectID:[[userInfo objectForKey:kKeyResourceID] integerValue]
                              objectKey:kKeySquareImageURL];
}    

@end
