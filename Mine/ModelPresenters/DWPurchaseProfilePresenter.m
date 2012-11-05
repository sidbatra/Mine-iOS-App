//
//  DWPurchaseProfilePresenter.m
//  Mine
//
//  Created by Siddharth Batra on 8/3/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWPurchaseProfilePresenter.h"
#import "DWModelSet.h"
#import "DWPurchaseProfileCell.h"
#import "DWPurchase.h"
#import "DWStore.h"
#import "DWUser.h"
#import "DWConstants.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWPurchaseProfilePresenter

//----------------------------------------------------------------------------------------------------
+ (UITableViewCell*)cellForObject:(id)object
                     withBaseCell:(id)base
               withCellIdentifier:(NSString*)identifier
                     withDelegate:(id)delegate
             andPresentationStyle:(NSInteger)style {
    
    DWModelSet *purchaseSet         = object;
    DWPurchaseProfileCell *cell     = base;
    
    if(!cell)
        cell = [[DWPurchaseProfileCell alloc] initWithStyle:UITableViewStylePlain 
                                            reuseIdentifier:identifier
                                                   userMode:style == kPurchaseProfilePresenterStyleWithUser];
    
    cell.delegate = delegate;
    
    [cell resetUI];
    
    for(NSInteger i=0 ; i<purchaseSet.length ; i++) {
        DWPurchase *purchase = [purchaseSet.models objectAtIndex:i];
        [purchase downloadGiantImage];
        
        [cell setPurchaseImage:purchase.giantImage
                      forIndex:i 
                withPurchaseID:purchase.databaseID];
        
        [cell setPurchaseTitle:purchase.title
                         store:purchase.store ? purchase.store.name : nil
                      forIndex:i
               withUserPronoun:purchase.user.pronoun
                withPurchaseID:purchase.databaseID];
        
        if(style == kPurchaseProfilePresenterStyleWithUser) {
            [purchase.user downloadSquareImage];
            [cell setUserImage:purchase.user.squareImage
                      forIndex:i
                    withUserID:purchase.user.databaseID];
        }
        else if(style == kPurchaseProfilePresenterStyleUnapproved) {
            [cell displayCrossButtonForIndex:i];
        }
        
        if(purchase.isDestroying)
            [cell enterSpinningStateForIndex:i];
    }
    
    return cell;
}

//----------------------------------------------------------------------------------------------------
+ (CGFloat)heightForObject:(id)object 
     withPresentationStyle:(NSInteger)style {
    
     DWModelSet *purchaseSet = object;
    
    return [DWPurchaseProfileCell heightForCellWithPurchases:purchaseSet.models
                                                  inUserMode:style == kPurchaseProfilePresenterStyleWithUser];
}

//----------------------------------------------------------------------------------------------------
+ (void)updatePresentationForCell:(id)base
                         ofObject:(id)object
            withPresentationStyle:(NSInteger)style
                  withObjectClass:(Class)objectClass
                     withObjectID:(NSInteger)objectID
                     andObjectKey:(NSString*)objectKey {
    
    
    DWModelSet *purchaseSet         = object;
    DWPurchaseProfileCell *cell     = base;
    
    if([DWPurchase class] == objectClass) {
        
        for(NSInteger i=0 ; i<purchaseSet.length ; i++) {
            DWPurchase *purchase = [purchaseSet.models objectAtIndex:i];
            
            if(purchase.databaseID == objectID) {
                [cell setPurchaseImage:purchase.giantImage
                              forIndex:i 
                        withPurchaseID:purchase.databaseID];
            }
        }
    }
    
    if(style == kPurchaseProfilePresenterStyleWithUser && [DWUser class] == objectClass && objectKey == kKeySquareImageURL) {
        for(NSInteger i=0 ; i<purchaseSet.length ; i++) {
            DWPurchase *purchase = [purchaseSet.models objectAtIndex:i];
            
            if(purchase.user.databaseID == objectID) {
                [cell setUserImage:purchase.user.squareImage
                          forIndex:i
                        withUserID:purchase.user.databaseID];
            }
        }

    }
}

//----------------------------------------------------------------------------------------------------
+ (void)cellClickedForObject:(id)object
                withBaseCell:(id)base
       withPresentationStyle:(NSInteger)style
                withDelegate:(id)delegate {
    
    
}

@end
