//
//  DWSession.m
//  Mine
//
//  Created by Siddharth Batra on 7/20/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWSession.h"

#import "SynthesizeSingleton.h"

static NSString* const kDiskKeyCurrentUser = @"DWSession_currentUser";


/**
 * Private declarations
 */
@interface DWSession()

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

@synthesize currentUser = _currentUser;

SYNTHESIZE_SINGLETON_FOR_CLASS(DWSession);

//----------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	
	if(self) {
		[self read];
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
- (void)create:(DWUser*)user {
	
    self.currentUser = user;
    //self.currentUser.isNewUser      = YES;
    //self.currentUser.isCurrentUser  = YES;
    
    [self write];
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


@end
