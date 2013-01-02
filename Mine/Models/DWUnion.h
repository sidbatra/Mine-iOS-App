//
//  DWUnion.h
//  Mine
//
//  Created by Siddharth Batra on 9/9/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * DWUnion is not implementationally a union but a logical one.
 * A subset of it's variables are used to store data used by the
 * presenter construct to display cells.
 */
@interface DWUnion : NSObject {
    NSString    *_title;
    NSString    *_subtitle;
}

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *subtitle;

- (void)setCustomKeyValue:(NSString*)key value:(id)value;
- (id)customValueforKey:(NSString*)key;

@end
