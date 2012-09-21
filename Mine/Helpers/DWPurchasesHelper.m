//
//  DWPurchasesHelper.m
//  Mine
//
//  Created by Siddharth Batra on 9/1/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWPurchasesHelper.h"

#import "DWUsersHelper.h"
#import "DWPurchase.h"
#import "DWUser.h"
#import "DWStore.h"


static NSDateFormatter *dateFormat;



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWPurchasesHelper

//----------------------------------------------------------------------------------------------------
+ (NSString*)timestamp:(DWPurchase*)purchase {
    
    if(!dateFormat) {
        dateFormat = [[NSDateFormatter alloc] init];
    }
    
    [dateFormat setDateFormat:@"d MMM"];
    
    
    NSString *timestamp = nil;
    CGFloat timeInterval = -[purchase.createdAt timeIntervalSinceNow];
    
    if(timeInterval < 86400)
        timestamp = @"Today";
    else if(timeInterval < 172800)
        timestamp = @"Yesterday";
    else {
        timestamp = [dateFormat stringFromDate:purchase.createdAt];
    }
    
    return timestamp;
}

//----------------------------------------------------------------------------------------------------
+ (NSString*)boughtTextForPurchase:(DWPurchase*)purchase {
    
    NSMutableString *boughtText = [NSMutableString stringWithFormat:@"%@ bought %@ %@",
                                   purchase.user.fullName,
                                   [DWUsersHelper genderPronounForUser:purchase.user],
                                   purchase.title];
    
    if(purchase.store) {
        [boughtText appendFormat:@" from %@",purchase.store.name];
    }
    
    return boughtText;
}

@end
