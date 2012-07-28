//
//  DWPurchaseFeedPresenter.m
//  Mine
//
//  Created by Siddharth Batra on 7/22/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWPurchaseFeedPresenter.h"

#import "DWPurchaseFeedCell.h"
#import "DWUser.h"
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

    cell.delegate   = delegate;
    cell.purchaseID = purchase.databaseID;
    
    [purchase downloadGiantImage];
    [purchase.user downloadSquareImage];
    
    [cell setPurchaseImage:purchase.giantImage];
    [cell setUserImage:purchase.user.squareImage];
    
    [cell setUserName:purchase.user.fullName];
    [cell setTitle:purchase.title];
    
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
                  withObjectClass:(Class)objectClass
                     withObjectID:(NSInteger)objectID
                     andObjectKey:(NSString*)objectKey {
    
    DWPurchase *purchase        = object;
    DWPurchaseFeedCell *cell    = base;
    
    if([purchase class] == objectClass && purchase.databaseID == objectID) {
        
        if(objectKey == kKeyGiantImageURL)
            [cell setPurchaseImage:purchase.giantImage];        
    }
    else if([purchase.user class] == objectClass && purchase.user.databaseID == objectID) {
            
        if(objectKey == kKeySquareImageURL)
            [cell setUserImage:purchase.user.squareImage];
    }
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
