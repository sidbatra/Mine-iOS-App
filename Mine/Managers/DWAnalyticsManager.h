//
//  DWAnalyticsManager.h
//  Mine
//
//  Created by Siddharth Batra on 8/7/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DWAnalyticsManager : NSObject {
    
}

/**
 * The sole shared instance of the class
 */
+ (DWAnalyticsManager*)sharedDWAnalyticsManager;


/**
 * Track an event along with additional properties.
 */
- (void)track:(NSString*)name withProperties:(NSMutableDictionary*)properties;

/**
 * Overloaded track method minus the properties.
 */
- (void)track:(NSString*)name;


/**
 * Track user data along with the version of the app the user is on.
 */
- (void)trackUserWithEmail:(NSString*)email 
                   withAge:(NSInteger)integer
                withGender:(NSString*)gender;

@end
