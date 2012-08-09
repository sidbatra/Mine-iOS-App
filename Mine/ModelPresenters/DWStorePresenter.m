//
//  DWStorePresenter.m
//  Mine
//
//  Created by Deepak Rao on 8/9/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWStorePresenter.h"
#import "DWStore.h"
#import "DWDoubleLineCell.h"

static CGFloat const kCellHeight  = 44;



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
    
    DWStore *store                      = object;
    DWDoubleLineCell *cell              = base;
    
    if(!cell)
        cell = [[DWDoubleLineCell alloc] initWithStyle:UITableViewStylePlain
                                       reuseIdentifier:identifier];
    
    [cell setFirstLine:store.name];

    [cell reset];
    [cell redisplay];
    
    return cell;
}

//----------------------------------------------------------------------------------------------------
+ (CGFloat)heightForObject:(id)object 
     withPresentationStyle:(NSInteger)style {
    
    return kCellHeight;
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

