//
//  DWSession.m
//  Mine
//
//  Created by Siddharth Batra on 7/20/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWSession.h"

#import "SynthesizeSingleton.h"
#import "DWAnalyticsManager.h"
#import "DWConstants.h"


static NSString* const kDiskKeyCurrentUser = @"DWSession_currentUser";
static NSTimeInterval const kMaxSessionLength = 60 * 60;

/**
 * Private declarations
 */
@interface DWSession() {
    DWStatusController      *_statusController;
    DWUsersController       *_usersController;
    DWPurchasesController   *_purchasesController;
    
    NSTimeInterval          _sessionRenewedAt;
}


@property (nonatomic,strong) DWStatusController *statusController;
@property (nonatomic,strong) DWUsersController *usersController;
@property (nonatomic,strong) DWPurchasesController *purchasesController;
@property (nonatomic,assign) NSTimeInterval sessionRenewedAt;


/**
 * Read the user session from disk using NSUserDefaults
 */
- (void)read;

/**
 * Write the current user to disk using NSUserDefaults
 */
- (void)write;

/**
 * Erase the current user from disk
 */
- (void)erase;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWSession

@synthesize currentUser         = _currentUser;
@synthesize statusController    = _statusController;
@synthesize purchasesController = _purchasesController;
@synthesize usersController     = _usersController;
@synthesize sessionRenewedAt    = _sessionRenewedAt;

SYNTHESIZE_SINGLETON_FOR_CLASS(DWSession);

//----------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	
	if(self) {
        
        [self read];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(applicationFinishedLaunching:) 
                                                     name:UIApplicationDidFinishLaunchingNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillEnterForeground:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        
        
        if([self isAuthenticated])
            [[DWAnalyticsManager sharedDWAnalyticsManager] trackUserWithEmail:self.currentUser.email
                                                                      withAge:self.currentUser.age
                                                                   withGender:self.currentUser.gender];
        
        self.usersController = [[DWUsersController alloc] init];
        self.usersController.delegate = self;
        
        self.purchasesController = [[DWPurchasesController alloc] init];
        self.purchasesController.delegate = self;
	}
	
	return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Disk IO

//----------------------------------------------------------------------------------------------------
- (void)write {
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	
	if (standardUserDefaults) {
        
		NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:self.currentUser]; 
        
        [standardUserDefaults setObject:userData
                                 forKey:kDiskKeyCurrentUser];
        
        [standardUserDefaults synchronize];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)read {
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	
	if (standardUserDefaults) {
		NSData *userData = [standardUserDefaults objectForKey:kDiskKeyCurrentUser];
        
        if(userData)
            self.currentUser = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)erase {
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	
	if (standardUserDefaults) {
        [standardUserDefaults removeObjectForKey:kDiskKeyCurrentUser];
        [standardUserDefaults synchronize];
    }
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Creation, Destruction, Management

//----------------------------------------------------------------------------------------------------
- (void)renewSession {
    self.sessionRenewedAt = [[NSDate date] timeIntervalSince1970];
}

//----------------------------------------------------------------------------------------------------
- (void)create:(DWUser*)user {
	
    self.currentUser = user;
    
    [self write];

    
    [[DWAnalyticsManager sharedDWAnalyticsManager] trackUserWithEmail:self.currentUser.email
                                                              withAge:self.currentUser.age
                                                           withGender:self.currentUser.gender];

}

//----------------------------------------------------------------------------------------------------
- (void)update {
    [self write];
}
//----------------------------------------------------------------------------------------------------
- (void)destroy {
    
    [self.currentUser destroy];
	self.currentUser = nil;
    
    [self erase];
}

//----------------------------------------------------------------------------------------------------
- (BOOL)isAuthenticated {
	return self.currentUser != nil;
}

//----------------------------------------------------------------------------------------------------
- (BOOL)isCurrentUser:(NSInteger)userID {
    return [self isAuthenticated] && self.currentUser.databaseID == userID;
}

//----------------------------------------------------------------------------------------------------
- (void)launchUserUpdateNotification {
    
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
                          self.currentUser, kKeyUser,
                          nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNUserManualUpdated
                                                        object:nil
                                                      userInfo:info];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)applicationFinishedLaunching:(NSNotification*)notification {
    
    [self renewSession];
    
    
    if(![self isAuthenticated])
        return;
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"User Logged In"];
    
    if(!self.statusController) {
        self.statusController = [[DWStatusController alloc] init];
        self.statusController.delegate = self;
    }
    
    [self.statusController getStatus];
}

//----------------------------------------------------------------------------------------------------
- (void)applicationWillEnterForeground:(NSNotification*)notification {

    if(![self isAuthenticated])
        return;
    
    if([[NSDate date] timeIntervalSince1970] - self.sessionRenewedAt > kMaxSessionLength) {
        [self renewSession];
        [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"User Logged In"];
    }

}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWStatusControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)statusLoaded:(DWUser *)user {
    [self update];
    [user debug];
    [user destroy];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWUsersControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)userUpdated:(DWUser *)user {
    [[DWSession sharedDWSession] update];
    [user destroy];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWPurchasesControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)purchaseCreated:(DWPurchase *)purchase
         fromResourceID:(NSNumber *)resourceID {
    
    self.currentUser.purchasesCount++;
    [self launchUserUpdateNotification];
}

//----------------------------------------------------------------------------------------------------
- (void)purchaseDeleted:(NSNumber *)purchaseID {
    
    self.currentUser.purchasesCount--;
    [self launchUserUpdateNotification];
}

@end
