//
//  DWNotificationManager.h
//  Mine
//
//  Created by Siddharth Batra on 8/8/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DWNotificationManager : NSObject


/**
 * The sole shared instance of the class
 */
+ (DWNotificationManager*)sharedDWNotificationManager;


/**
 * Tests if the device token is different from the current one and
 * updates it locally and remotely.
 */
- (void)updateDeviceToken:(NSData*)deviceToken;

@end
