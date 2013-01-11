//
//  DWMessagePresenter.m
//  Mine
//
//  Created by Siddharth Batra on 1/9/13.
//  Copyright (c) 2013 Denwen, Inc. All rights reserved.
//

#import "DWMessagePresenter.h"

#import "DWMessage.h"
#import "DWMessageCell.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWMessagePresenter

//----------------------------------------------------------------------------------------------------
+ (UITableViewCell*)cellForObject:(id)object
                     withBaseCell:(id)base
               withCellIdentifier:(NSString*)identifier
                     withDelegate:(id)delegate
             andPresentationStyle:(NSInteger)style {
    
    DWMessage *message = object;
    DWMessageCell *cell   = base;
    
    if(!cell)
        cell = [[DWMessageCell alloc] initWithStyle:UITableViewStylePlain
                                  reuseIdentifier:identifier];
    
    [cell setMessage:message.title];
    
    return cell;
}

//----------------------------------------------------------------------------------------------------
+ (CGFloat)heightForObject:(id)object
     withPresentationStyle:(NSInteger)style {
    
    return [DWMessageCell height];
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
}

@end
