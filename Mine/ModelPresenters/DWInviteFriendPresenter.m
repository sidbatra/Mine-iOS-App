//
//  DWInviteFriendPresenter.m
//  Mine
//
//  Created by Siddharth Batra on 9/9/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWInviteFriendPresenter.h"
#import "DWUnion.h"
#import "DWInviteFriendCell.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWInviteFriendPresenter

//----------------------------------------------------------------------------------------------------
+ (UITableViewCell*)cellForObject:(id)object
                     withBaseCell:(id)base
               withCellIdentifier:(NSString*)identifier
                     withDelegate:(id)delegate
             andPresentationStyle:(NSInteger)style {
    
    DWUnion *uni = object;
    DWInviteFriendCell *cell = base;
    
    if(!cell)
        cell = [[DWInviteFriendCell alloc] initWithStyle:UITableViewStylePlain 
                                    reuseIdentifier:identifier];
    
    [cell setMessage:uni.title];
    
    return cell;
}

//----------------------------------------------------------------------------------------------------
+ (CGFloat)heightForObject:(id)object 
     withPresentationStyle:(NSInteger)style {
    
    return [DWInviteFriendCell heightForCell];
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
    
    SEL sel = @selector(inviteFriendClicked:);
    
    if(![delegate respondsToSelector:sel])
        return;
    
    
    [delegate performSelector:sel 
                   withObject:object];
    
}

@end
