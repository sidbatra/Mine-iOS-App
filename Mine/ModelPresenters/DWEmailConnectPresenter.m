//
//  DWEmailConnectPresenter.m
//  Mine
//
//  Created by Deepak Rao on 11/6/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWEmailConnectPresenter.h"
#import "DWUnion.h"
#import "DWUser.h"
#import "DWEmailConnectCell.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWEmailConnectPresenter

//----------------------------------------------------------------------------------------------------
+ (UITableViewCell*)cellForObject:(id)object
                     withBaseCell:(id)base
               withCellIdentifier:(NSString*)identifier
                     withDelegate:(id)delegate
             andPresentationStyle:(NSInteger)style {
    
    DWUnion *uni = object;
    DWEmailConnectCell *cell = base;
    
    if(!cell)
        cell = [[DWEmailConnectCell alloc] initWithStyle:UITableViewStylePlain
                                         reuseIdentifier:identifier];
    
    cell.delegate = delegate;
    
    NSLog(@"AUTH VALUES - %d %d %d",
          [[uni customValueforKey:kKeyIsGoogleAuthorized] boolValue],
          [[uni customValueforKey:kKeyIsYahooAuthorized] boolValue],
          [[uni customValueforKey:kKeyIsHotmailAuthorized] boolValue]);
    
    [cell setTitle:uni.title
       andSubtitle:uni.subtitle];
    
    return cell;
}

//----------------------------------------------------------------------------------------------------
+ (CGFloat)heightForObject:(id)object
     withPresentationStyle:(NSInteger)style {
    
    return [DWEmailConnectCell heightForCell];
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
