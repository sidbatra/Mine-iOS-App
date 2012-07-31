//
//  DWProductPresenter.m
//  Mine
//
//  Created by Deepak Rao on 7/30/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWProductPresenter.h"

#import "DWPurchaseFeedCell.h"
#import "DWProduct.h"

@implementation DWProductPresenter


//----------------------------------------------------------------------------------------------------
+ (UITableViewCell*)cellForObject:(id)object
                     withBaseCell:(id)base
               withCellIdentifier:(NSString*)identifier
                     withDelegate:(id)delegate
             andPresentationStyle:(NSInteger)style {
    
    DWProduct *product          = object;
    DWPurchaseFeedCell *cell    = base;
    
    if(!cell)
        cell = [[DWPurchaseFeedCell alloc] initWithStyle:UITableViewStylePlain 
                                         reuseIdentifier:identifier];
    
    cell.delegate   = delegate;
    cell.purchaseID = product.databaseID;
        
    [product downloadMediumImage];

    [cell setPurchaseImage:product.mediumImage];
    [cell setTitle:product.title];
    
    return cell;
}

//----------------------------------------------------------------------------------------------------
+ (CGFloat)heightForObject:(id)object 
     withPresentationStyle:(NSInteger)style {
    
    return [DWPurchaseFeedCell heightForCellWithLikesCount:0 
                                          andCommentsCount:0];
}

//----------------------------------------------------------------------------------------------------
+ (void)updatePresentationForCell:(id)base
                         ofObject:(id)object
            withPresentationStyle:(NSInteger)style
                  withObjectClass:(Class)objectClass
                     withObjectID:(NSInteger)objectID
                     andObjectKey:(NSString*)objectKey {
    
    DWProduct *product          = object;
    DWPurchaseFeedCell *cell    = base;
    
    if([product class] == objectClass && product.databaseID == objectID) {

        if(objectKey == kKeyMediumImageURL)
            [cell setPurchaseImage:product.mediumImage];        
    }
}

//----------------------------------------------------------------------------------------------------
+ (void)cellClickedForObject:(id)object
                withBaseCell:(id)base
       withPresentationStyle:(NSInteger)style
                withDelegate:(id)delegate {

    
}

@end
