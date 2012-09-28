//
//  DWPurchaseFeedPresenter.m
//  Mine
//
//  Created by Siddharth Batra on 7/22/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWPurchaseFeedPresenter.h"

#import "DWPurchaseFeedCell.h"
#import "DWPurchasesHelper.h"
#import "DWSession.h"

#import "DWUser.h"
#import "DWLike.h"
#import "DWComment.h"
#import "DWPurchase.h"
#import "DWConstants.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWPurchaseFeedPresenter

//----------------------------------------------------------------------------------------------------
+ (UITableViewCell*)cellForObject:(id)object
                     withBaseCell:(id)base
               withCellIdentifier:(NSString*)identifier
                     withDelegate:(id)delegate
             andPresentationStyle:(NSInteger)style {
    
    DWPurchase *purchase        = object;
    DWPurchaseFeedCell *cell    = base;
    
    BOOL isInteractve = style != kPurchaseFeedPresenterStyleDisabled;
    
    if(!cell)
        cell = [[DWPurchaseFeedCell alloc] initWithStyle:UITableViewStylePlain 
                                         reuseIdentifier:identifier];

    cell.delegate   = delegate;
    cell.isInteractive  = isInteractve;
    cell.purchaseID = purchase.databaseID;
    cell.userID     = purchase.user.databaseID;
    
    [cell resetLikesUI];
    [cell resetCommentsUI];
    
    [purchase downloadGiantImage];
    [purchase.user downloadSquareImage];
    
    [cell setPurchaseImage:purchase.giantImage];
    [cell setUserImage:purchase.user.squareImage];
    
    [cell setBoughtText:[DWPurchasesHelper boughtTextForPurchase:purchase]
           withUserName:purchase.user.fullName
          withTimestamp:[DWPurchasesHelper timestamp:purchase]];
    
    [cell setEndorsement:purchase.endorsement];
    
    
    if(isInteractve) {
        [cell setLikeCount:[purchase.likes count]];
        
        
        for(NSInteger i=0 ; i<MIN(kTotalLikeUserImages,[purchase.likes count]) ; i++) {
            DWLike *like = [purchase.likes objectAtIndex:[purchase.likes count]-1-i];
            
            [like.user downloadSquareImage];
            
            [cell setLikeImage:like.user.squareImage
              forButtonAtIndex:i
                     forUserID:like.user.databaseID];
        }
        
        for(NSInteger i=0 ; i<MIN(kTotalComments,[purchase.comments count]) ; i++) {
            DWComment *comment = [purchase.comments objectAtIndex:i];
            
            [comment.user downloadSquareImage];
            
            [cell createCommentWithUserImage:comment.user.squareImage
                                withUserName:comment.user.fullName
                                  withUserID:comment.user.databaseID
                                  andMessage:comment.message];
        }
        
        if([purchase.comments count] > kTotalComments)
            [cell setAllCommentsButtonWithCount:[purchase.comments count]];
    }
    
    [cell setInteractionButtonsWithLikedStatus:[purchase isLikedByUserID:[DWSession sharedDWSession].currentUser.databaseID]];
    
    
    return cell;
}

//----------------------------------------------------------------------------------------------------
+ (CGFloat)heightForObject:(id)object 
     withPresentationStyle:(NSInteger)style {
    
     DWPurchase *purchase = object;
    
    return [DWPurchaseFeedCell heightForCellWithLikesCount:purchase.likes.count 
                                                  comments:purchase.comments
                                             isInteractive:style != kPurchaseFeedPresenterStyleDisabled
                                               endorsement:purchase.endorsement
                                                boughtText:[DWPurchasesHelper boughtTextForPurchase:purchase]
                                                 timestamp:[DWPurchasesHelper timestamp:purchase]
                                                  userName:purchase.user.fullName];
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
                
            for(NSInteger i=0 ; i<MIN(kTotalLikeUserImages,[purchase.likes count]) ; i++) {
                DWLike *like = [purchase.likes objectAtIndex:[purchase.likes count]-1-i];
                
                if(like.user.databaseID == objectID) {
                    [cell setLikeImage:like.user.squareImage
                      forButtonAtIndex:i
                             forUserID:like.user.databaseID];
                    break;
                }
            } //likes
            
            
            for(NSInteger i=0 ; i< [purchase.comments count] ; i++) {
                DWComment *comment = [purchase.comments objectAtIndex:i];
                
                if(comment.user.databaseID == objectID)
                    [cell setCommentUserImage:comment.user.squareImage
                             forButtonAtIndex:i];
            } //comments
            
            
            
        } // if square image
    } //if user
}

//----------------------------------------------------------------------------------------------------
+ (void)cellClickedForObject:(id)object
                withBaseCell:(id)base
       withPresentationStyle:(NSInteger)style
                withDelegate:(id)delegate {
    
    /*
    SEL sel             = @selector(:);
    //DWPurchase *purchase  = object;
    
    if(![delegate respondsToSelector:sel])
        return;
    
    
    [delegate performSelector:sel 
                   withObject:object];
    */
}

@end
