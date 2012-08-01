//
//  DWProductPresenter.m
//  Mine
//
//  Created by Deepak Rao on 7/30/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWProductPresenter.h"

#import "DWProductCell.h"
#import "DWProductSet.h"

@implementation DWProductPresenter


//----------------------------------------------------------------------------------------------------
+ (UITableViewCell*)cellForObject:(id)object
                     withBaseCell:(id)base
               withCellIdentifier:(NSString*)identifier
                     withDelegate:(id)delegate
             andPresentationStyle:(NSInteger)style {

    DWProductSet *productSet    = object;
    DWProductCell *cell         = base;
    
    if(!cell)
        cell = [[DWProductCell alloc] initWithStyle:UITableViewStylePlain 
                                         reuseIdentifier:identifier];
    
    [cell resetUI];
    
    for(NSInteger i=0 ; i< [productSet length] ; i++) {
        DWProduct *product = [productSet.products objectAtIndex:i];
        [product downloadMediumImage];
        
        [cell setProductImage:product.mediumImage
             forButtonAtIndex:i 
                 andProductID:product.databaseID];
    }

    return cell;
}

//----------------------------------------------------------------------------------------------------
+ (CGFloat)heightForObject:(id)object 
     withPresentationStyle:(NSInteger)style {
    
    return kProductCellHeight;
}

//----------------------------------------------------------------------------------------------------
+ (void)updatePresentationForCell:(id)base
                         ofObject:(id)object
            withPresentationStyle:(NSInteger)style
                  withObjectClass:(Class)objectClass
                     withObjectID:(NSInteger)objectID
                     andObjectKey:(NSString*)objectKey {
    
    
    DWProductSet *productSet    = object;
    DWProductCell *cell         = base;
            
    if([productSet class] == objectClass) {
        
        for(NSInteger i=0 ; i< [productSet length] ; i++) {
            DWProduct *product = [productSet.products objectAtIndex:i];
        
            if(product.databaseID == objectID) {
                [cell setProductImage:product.mediumImage 
                     forButtonAtIndex:i 
                         andProductID:product.databaseID];
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