//
//  DWPurchaseFeedPresenter.m
//  Mine
//
//  Created by Siddharth Batra on 7/22/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWPurchaseFeedPresenter.h"

#import "DWPurchaseFeedCell.h"
#import "DWPurchase.h"

@implementation DWPurchaseFeedPresenter


//----------------------------------------------------------------------------------------------------
+ (UITableViewCell*)cellForObject:(id)object
                     withBaseCell:(id)base
               withCellIdentifier:(NSString*)identifier
                     withDelegate:(id)delegate
             andPresentationStyle:(NSInteger)style {
    
    DWPurchase *purchase        = object;
    DWPurchaseFeedCell *cell    = base;
    
    if(!cell)
        cell = [[DWPurchaseFeedCell alloc] initWithStyle:UITableViewStylePlain 
                                         reuseIdentifier:identifier];
    [purchase downloadGiantImage];
    
    [cell setPurchaseImage:purchase.giantImage];
    [cell setMessage:purchase.title];
    
    return cell;
}

//----------------------------------------------------------------------------------------------------
+ (CGFloat)heightForObject:(id)object 
     withPresentationStyle:(NSInteger)style {
    
    return kPurchaseFeedCellHeight;
}

//----------------------------------------------------------------------------------------------------
+ (void)updatePresentationForCell:(id)base
                         ofObject:(id)object
            withPresentationStyle:(NSInteger)style
                  withNewResource:(id)resource
                 havingResourceID:(NSInteger)resourceID
                           ofType:(NSInteger)resourceType {    
}

//----------------------------------------------------------------------------------------------------
+ (void)cellClickedForObject:(id)object
                withBaseCell:(id)base
       withPresentationStyle:(NSInteger)style
                withDelegate:(id)delegate {
    
    SEL sel             = @selector(messageClicked:);
    //DWPurchase *purchase  = object;
    
    if(![delegate respondsToSelector:sel])
        return;
    
    
    [delegate performSelector:sel 
                   withObject:object];
    
}

@end
