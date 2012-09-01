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



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWPurchasesHelper

//----------------------------------------------------------------------------------------------------
+ (NSString*)boughtTextForPurchase:(DWPurchase*)purchase {
    NSString *title = [purchase.title length] < 20 ? 
                        purchase.title : 
                        [NSString stringWithFormat:@"%@...",[purchase.title substringToIndex:17]];
    
    NSMutableString *boughtText = [NSMutableString stringWithFormat:@"%@ bought %@ %@",
                                   purchase.user.fullName,
                                   [DWUsersHelper genderPronounForUser:purchase.user],
                                   title];
    
    if(purchase.store) {
        [boughtText appendFormat:@" from %@",purchase.store.name];
    }
    
    return boughtText;
}

@end
