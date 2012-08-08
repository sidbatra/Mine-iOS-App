//
//  DWNotificationManager.m
//  Mine
//
//  Created by Siddharth Batra on 8/8/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWNotificationManager.h"

#import "DWUsersController.h"
#import "DWSession.h"

#import "SynthesizeSingleton.h"


@interface DWNotificationManager() {
    DWUsersController   *_usersController;
}

/**
 * Data controller for the users controller.
 */
@property (nonatomic,strong) DWUsersController *usersController;

@end




//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWNotificationManager

@synthesize usersController = _usersController;

SYNTHESIZE_SINGLETON_FOR_CLASS(DWNotificationManager);

//----------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	
	if(self) {
	}
	
	return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {	
}

//----------------------------------------------------------------------------------------------------
- (void)updateDeviceToken:(NSData*)deviceToken {
    
    if(![[DWSession sharedDWSession] isAuthenticated])
        return;

    
    NSString* token = [NSString stringWithFormat:@"%@",deviceToken];
    token = [[token substringWithRange:NSMakeRange(1, [token length]-2)] stringByReplacingOccurrencesOfString:@" " withString:@""];

    
    if([token isEqualToString:[DWSession sharedDWSession].currentUser.iphoneDeviceToken])
        return;
    
    
    self.usersController = [[DWUsersController alloc] init];
    [self.usersController updateUserHavingID:[DWSession sharedDWSession].currentUser.databaseID 
                       withiphoneDeviceToken:token];
        
}

@end
