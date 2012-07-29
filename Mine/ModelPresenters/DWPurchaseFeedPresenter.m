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
#import "DWLike.h"
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
    cell.userID     = purchase.user.databaseID;
    
    [cell resetLikeUI];
    
    [purchase downloadGiantImage];
    [purchase.user downloadSquareImage];
    
    [cell setPurchaseImage:purchase.giantImage];
    [cell setUserImage:purchase.user.squareImage];
    
    [cell setUserName:purchase.user.fullName];
    [cell setTitle:purchase.title];
    
    [cell setLikeCount:[purchase.likes count]];
    
    for(NSInteger i=0 ; i<MIN(kTotalLikeUserButtons,[purchase.likes count]) ; i++) {
        DWLike *like = [purchase.likes objectAtIndex:i];
        
        [like.user downloadSquareImage];
        
        [cell setLikeImage:like.user.squareImage
          forButtonAtIndex:i
                 forUserID:like.user.databaseID];
    }
    
    
    return cell;
}

//----------------------------------------------------------------------------------------------------
+ (CGFloat)heightForObject:(id)object 
     withPresentationStyle:(NSInteger)style {
    
     DWPurchase *purchase = object;
    
    return [DWPurchaseFeedCell heightForCellWithLikes:purchase.likes];
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
    else if([purchase.user class] == objectClass) {
            
        if(objectKey == kKeySquareImageURL) {
            
            if(purchase.user.databaseID == objectID)
                [cell setUserImage:purchase.user.squareImage];
                
            for(NSInteger i=0 ; i<MIN(kTotalLikeUserButtons,[purchase.likes count]) ; i++) {
                DWLike *like = [purchase.likes objectAtIndex:i];
                    
                if(like.user.databaseID == objectID) {
                    [cell setLikeImage:like.user.squareImage
                      forButtonAtIndex:i
                             forUserID:like.user.databaseID];
                    break;
                }
            }
        } // if square image
    } //if user
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
