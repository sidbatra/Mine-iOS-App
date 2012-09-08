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
	}
	
	return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {	
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
}

//----------------------------------------------------------------------------------------------------
- (void)followingDestroyed:(DWFollowing *)following 
                 forUserID:(NSNumber *)userID {
    
    DWFollowing *existingFollowing = [self followingForUserID:[userID integerValue]];
    
    if(existingFollowing)
        [existingFollowing forceDestroy];
}

@end
