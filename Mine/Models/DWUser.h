//
//  DWUser.h
//  Mine
//
//  Created by Siddharth Batra on 7/20/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWPoolObject.h"

@interface DWUser : DWPoolObject<NSCoding>  {
	NSString        *_firstName;
	NSString        *_lastName;
}

/**
 * First name of the user
 */
@property (nonatomic,copy) NSString *firstName;

/**
 * Last name of the user
 */
@property (nonatomic,copy) NSString *lastName;


@end
