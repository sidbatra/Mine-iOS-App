//
//  DWPurchasesHelper.h
//  Mine
//
//  Created by Siddharth Batra on 9/1/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DWPurchase;

@interface DWPurchasesHelper : NSObject

+ (NSString*)timestamp:(DWPurchase*)purchase;
+ (NSString*)boughtTextForPurchase:(DWPurchase*)purchase;

@end
