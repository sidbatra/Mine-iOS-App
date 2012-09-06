//
//  DWUserProfilePresenter.m
//  Mine
//
//  Created by Siddharth Batra on 9/4/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWUserProfilePresenter.h"

#import "DWUserProfileCell.h"
#import "DWUser.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUserProfilePresenter

//----------------------------------------------------------------------------------------------------
+ (UITableViewCell*)cellForObject:(id)object
                     withBaseCell:(id)base
               withCellIdentifier:(NSString*)identifier
                     withDelegate:(id)delegate
             andPresentationStyle:(NSInteger)style {
    
    DWUser *user                = object;
    DWUserProfileCell *cell     = base;
    
    if(!cell)
        cell = [[DWUserProfileCell alloc] initWithStyle:UITableViewStylePlain 
                                        reuseIdentifier:identifier];
    
    [cell resetUI];
    
    [user downloadSquareImage];
    
    [cell setUserImage:user.squareImage];
    [cell setUserName:user.fullName];
    [cell setByline:user.byline 
    followingsCount:user.followingsCount 
     followersCount:user.inverseFollowingsCount];
    
    return cell;
}

//----------------------------------------------------------------------------------------------------
+ (CGFloat)heightForObject:(id)object 
     withPresentationStyle:(NSInteger)style {
    
    DWUser *user = object;
    
    return [DWUserProfileCell heightForCellWithByline:user.byline 
                                     connectionsCount:user.followingsCount+user.inverseFollowingsCount];
}

//----------------------------------------------------------------------------------------------------
+ (void)updatePresentationForCell:(id)base
                         ofObject:(id)object
            withPresentationStyle:(NSInteger)style
                  withObjectClass:(Class)objectClass
                     withObjectID:(NSInteger)objectID
                     andObjectKey:(NSString*)objectKey {
    
    
    DWUser *user                = object;
    DWUserProfileCell *cell     = base;
    
    if([user class] == objectClass && user.databaseID == objectID && objectKey == kKeySquareImageURL) {
        [cell setUserImage:user.squareImage];
    }
}

//----------------------------------------------------------------------------------------------------
+ (void)cellClickedForObject:(id)object
                withBaseCell:(id)base
       withPresentationStyle:(NSInteger)style
                withDelegate:(id)delegate {
}

@end
