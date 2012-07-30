//
//  DWCommentPresenter.m
//  Mine
//
//  Created by Siddharth Batra on 7/30/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWCommentPresenter.h"

#import "DWCommentCell.h"
#import "DWUser.h"
#import "DWComment.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWCommentPresenter

//----------------------------------------------------------------------------------------------------
+ (UITableViewCell*)cellForObject:(id)object
                     withBaseCell:(id)base
               withCellIdentifier:(NSString*)identifier
                     withDelegate:(id)delegate
             andPresentationStyle:(NSInteger)style {
    
    DWComment *comment      = object;
    DWCommentCell *cell     = base;
    
    if(!cell)
        cell = [[DWCommentCell alloc] initWithStyle:UITableViewStylePlain 
                                    reuseIdentifier:identifier];
    
    cell.delegate   = delegate;
    cell.commentID  = comment.databaseID;
    
    [comment.user downloadSquareImage];
    
    [cell setUserImage:comment.user.squareImage];
    [cell setUserName:comment.user.fullName];
    [cell setMessage:comment.message];
    
    return cell;
}

//----------------------------------------------------------------------------------------------------
+ (CGFloat)heightForObject:(id)object 
     withPresentationStyle:(NSInteger)style {
    
    DWComment *comment = object;
    
    return [DWCommentCell heightForCellWithMessage:comment.message];
}

//----------------------------------------------------------------------------------------------------
+ (void)updatePresentationForCell:(id)base
                         ofObject:(id)object
            withPresentationStyle:(NSInteger)style
                  withObjectClass:(Class)objectClass
                     withObjectID:(NSInteger)objectID
                     andObjectKey:(NSString*)objectKey {
    
    DWComment *comment      = object;
    DWCommentCell *cell     = base;
   
    if([comment.user class] == objectClass && objectKey == kKeySquareImageURL && comment.user.databaseID == objectID) {
        [cell setUserImage:comment.user.squareImage];
    }
}

//----------------------------------------------------------------------------------------------------
+ (void)cellClickedForObject:(id)object
                withBaseCell:(id)base
       withPresentationStyle:(NSInteger)style
                withDelegate:(id)delegate {
    
    SEL sel             = @selector(messageClicked:);
    
    if(![delegate respondsToSelector:sel])
        return;
    
    
    [delegate performSelector:sel 
                   withObject:object];
    
}

@end
