//
//  DWUserPresenter.m
//  Mine
//
//  Created by Siddharth Batra on 8/2/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWUserPresenter.h"

#import "DWFollowingManager.h"

#import "DWUserCell.h"
#import "DWUser.h"
#import "DWFollowing.h"

#import "DWConstants.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUserPresenter

//----------------------------------------------------------------------------------------------------
+ (UITableViewCell*)cellForObject:(id)object
                     withBaseCell:(id)base
               withCellIdentifier:(NSString*)identifier
                     withDelegate:(id)delegate
             andPresentationStyle:(NSInteger)style {
    
    DWUser *user        = object;
    DWUserCell *cell    = base;
    
    if(!cell)
        cell = [[DWUserCell alloc] initWithStyle:UITableViewStylePlain 
                                 reuseIdentifier:identifier];
    
    cell.userID = user.databaseID;
    cell.delegate = delegate;
    
    [cell resetUI];
    
    [user downloadSquareImage];
    
    [cell setUserImage:user.squareImage];
    [cell setUserName:user.fullName];
    
    
    if([DWFollowingManager sharedDWFollowingManager].areBulkFollowingsLoaded) {
        if([[DWFollowingManager sharedDWFollowingManager] followingForUserID:user.databaseID])
            [cell displayActiveFollowing];
        else
            [cell displayInactiveFollowing]; 
    }
    
    return cell;
}

//----------------------------------------------------------------------------------------------------
+ (CGFloat)heightForObject:(id)object 
     withPresentationStyle:(NSInteger)style {
    
    return [DWUserCell heightForCell];
}

//----------------------------------------------------------------------------------------------------
+ (void)updatePresentationForCell:(id)base
                         ofObject:(id)object
            withPresentationStyle:(NSInteger)style
                  withObjectClass:(Class)objectClass
                     withObjectID:(NSInteger)objectID
                     andObjectKey:(NSString*)objectKey {
    
    
    DWUser *user            = object;    
    DWUserCell *cell        = base;
    
    if([user class] == objectClass && user.databaseID == objectID) {
        if(objectKey == kKeySquareImageURL)
            [cell setUserImage:user.squareImage];
        else if(objectKey == kKeyFollowingCreated)
            [cell displayActiveFollowing];
        else if(objectKey == kKeyFollowingDestroyed)
            [cell displayInactiveFollowing];
    }
    
    if([user class] == objectClass && objectKey == kKeyFollowing) {
        if([[DWFollowingManager sharedDWFollowingManager] followingForUserID:user.databaseID])
                [cell displayActiveFollowing];
        else
            [cell displayInactiveFollowing];
    }
}

//----------------------------------------------------------------------------------------------------
+ (void)cellClickedForObject:(id)object
                withBaseCell:(id)base
       withPresentationStyle:(NSInteger)style
                withDelegate:(id)delegate {
    
    
    SEL sel = @selector(userPresenterUserSelected:);
    
    if(![delegate respondsToSelector:sel])
        return;
    
    
    DWUser *user = object;
    
    [delegate performSelector:sel
                   withObject:user];
    
}

@end
