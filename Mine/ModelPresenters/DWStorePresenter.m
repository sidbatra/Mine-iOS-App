//
//  DWStorePresenter.m
//  Mine
//
//  Created by Deepak Rao on 8/9/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWStorePresenter.h"
#import "DWStore.h"
#import "DWStoreCell.h"

static NSInteger const kStoreCellHeight = 43;

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWStorePresenter

//----------------------------------------------------------------------------------------------------
+ (UITableViewCell*)cellForObject:(id)object
                     withBaseCell:(id)base
               withCellIdentifier:(NSString*)identifier
                     withDelegate:(id)delegate
             andPresentationStyle:(NSInteger)style {
    
    DWStore *store      = object;
    DWStoreCell *cell   = base;
    
    if(!cell)
        cell = [[DWStoreCell alloc] initWithStyle:UITableViewStylePlain
                                       reuseIdentifier:identifier];
    
    [cell setStoreName:store.name];
    
    return cell;
}

//----------------------------------------------------------------------------------------------------
+ (CGFloat)heightForObject:(id)object 
     withPresentationStyle:(NSInteger)style {
    
    return kStoreCellHeight;
}

//----------------------------------------------------------------------------------------------------
+ (void)updatePresentationForCell:(id)base
                         ofObject:(id)object
            withPresentationStyle:(NSInteger)style
                  withObjectClass:(Class)objectClass
                     withObjectID:(NSInteger)objectID
                     andObjectKey:(NSString*)objectKey {
    
}

//----------------------------------------------------------------------------------------------------
+ (void)cellClickedForObject:(id)object
                withBaseCell:(id)base
       withPresentationStyle:(NSInteger)style
                withDelegate:(id)delegate {
    
    SEL sel = @selector(storeClicked:);
    
    if(![delegate respondsToSelector:sel])
        return;
    
    DWStore *store = object;
    
    [delegate performSelector:sel 
                   withObject:store];
}

@end

