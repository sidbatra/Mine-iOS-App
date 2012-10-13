//
//  DWFollowingManager.m
//  Mine
//
//  Created by Siddharth Batra on 9/8/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWFollowingManager.h"
#import "DWMemoryPool.h"
#import "DWFollowing.h"
#import "DWUser.h"
#import "DWUsersController.h"
#import "DWSession.h"
#import "DWAnalyticsManager.h"
#import "DWConstants.h"

#import "NSObject+Helpers.h"

#import "SynthesizeSingleton.h"


@interface DWFollowingManager() {
    DWFollowingsController *_followingsController;
}

@property (nonatomic,strong) DWFollowingsController *followingsController;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWFollowingManager

@synthesize areBulkFollowingsLoaded = _areBulkFollowingsLoaded;
@synthesize followingsController    = _followingsController;

SYNTHESIZE_SINGLETON_FOR_CLASS(DWFollowingManager);

//----------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	
	if(self) {
        self.followingsController = [[DWFollowingsController alloc] init];
        self.followingsController.delegate = self;
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(sessionRenewed:)
                                                     name:kNSessionRenewed
                                                   object:nil];
	}
	
	return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//----------------------------------------------------------------------------------------------------
- (DWFollowing*)followingForUserID:(NSInteger)userID {
    
    NSMutableDictionary *followings = [[DWMemoryPool sharedDWMemoryPool] poolForClass:[DWFollowing className]];
    DWFollowing *result = nil;
    
    for(DWFollowing *following in [followings allValues]) {
        if(following.userID == userID) {
            result = following;
            break;
        }
    }
    
    return result;
}

//----------------------------------------------------------------------------------------------------
- (void)launchManualUpdateForUser:(DWUser*)user {
    
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
                          user, kKeyUser,
                          nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNUserManualUpdated
                                                        object:nil
                                                      userInfo:info];
}

//----------------------------------------------------------------------------------------------------
- (void)modifyFollowingCountForUserID:(NSInteger)userID 
                              byCount:(NSInteger)count {
    
    DWUser *user = [DWUser fetch:userID];
    
    if(user) {
        user.followingsCount += count;
        [self launchManualUpdateForUser:user];
    }
    
    user = [DWSession sharedDWSession].currentUser;
    
    if(user) {
        user.inverseFollowingsCount += count;
        [self launchManualUpdateForUser:user];
    }
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWFollowingsControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)followingsLoaded:(NSMutableArray *)followings {
    self.areBulkFollowingsLoaded = YES;
}

//----------------------------------------------------------------------------------------------------
- (void)followingLoaded:(DWFollowing *)following 
              forUserID:(NSNumber *)userID {
}

//----------------------------------------------------------------------------------------------------
- (void)followingCreated:(DWFollowing *)following 
               forUserID:(NSNumber *)userID {
    
    [self modifyFollowingCountForUserID:[userID integerValue]
                                byCount:1];
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Following Created"];
}

//----------------------------------------------------------------------------------------------------
- (void)followingDestroyed:(DWFollowing *)following 
                 forUserID:(NSNumber *)userID {
    
    DWFollowing *existingFollowing = [self followingForUserID:[userID integerValue]];
    
    if(existingFollowing)
        [existingFollowing forceDestroy];
    
    
   [self modifyFollowingCountForUserID:[userID integerValue]
                               byCount:-1];
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Following Destroyed"];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)sessionRenewed:(NSNotification*)notification {
    self.areBulkFollowingsLoaded = NO;
}

@end
