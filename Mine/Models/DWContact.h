//
//  DWContact.h
//  Mine
//
//  Created by Deepak Rao on 7/26/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A model object to hold address book contact properties
 */
@interface DWContact : NSObject {
    
    NSString    *_firstName;    
    NSString    *_lastName;
    NSString    *_fullName;
    NSString    *_email;
}

/**
 * First name of the contact
 */
@property (nonatomic,copy) NSString *firstName;

/**
 * Last name of the contact
 */
@property (nonatomic,copy) NSString *lastName;

/**
 * Full name of the contact
 */
@property (nonatomic,copy) NSString *fullName;

/**
 * Email of the contact
 */
@property (nonatomic,copy) NSString *email;


/**
 * Generates URL style string containing all the members for debugging
 */
- (NSString*)debugString;

@end
