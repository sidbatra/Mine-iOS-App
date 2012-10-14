//
//  DWNotificationPresenter.m
//  Mine
//
//  Created by Siddharth Batra on 10/14/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWNotificationPresenter.h"

#import "DWNotificationCell.h"
#import "DWNotification.h"
#import "DWConstants.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWNotificationPresenter

//----------------------------------------------------------------------------------------------------
+ (UITableViewCell*)cellForObject:(id)object
                     withBaseCell:(id)base
               withCellIdentifier:(NSString*)identifier
                     withDelegate:(id)delegate
             andPresentationStyle:(NSInteger)style {
    
    DWNotification *notification = object;
    DWNotificationCell *cell     = base;
    
    if(!cell)
        cell = [[DWNotificationCell alloc] initWithStyle:UITableViewStylePlain
                                         reuseIdentifier:identifier];
    
    [notification downloadImage];
    
    [cell setNotificationImage:notification.image];
    [cell setEvent:notification.event entity:notification.entity];
    
    return cell;
}

//----------------------------------------------------------------------------------------------------
+ (CGFloat)heightForObject:(id)object
     withPresentationStyle:(NSInteger)style {
    
    DWNotification *notification = object;
    
    return [DWNotificationCell heightForCellWithEvent:notification.event
                                               entity:notification.entity];
}

//----------------------------------------------------------------------------------------------------
+ (void)updatePresentationForCell:(id)base
                         ofObject:(id)object
            withPresentationStyle:(NSInteger)style
                  withObjectClass:(Class)objectClass
                     withObjectID:(NSInteger)objectID
                     andObjectKey:(NSString*)objectKey {
    
    DWNotification *notification = object;
    DWNotificationCell *cell     = base;
    
    if([notification class] == objectClass && objectKey == kKeyImageURL && notification.databaseID == objectID) {
        [cell setNotificationImage:notification.image];
    }
}

//----------------------------------------------------------------------------------------------------
+ (void)cellClickedForObject:(id)object
                withBaseCell:(id)base
       withPresentationStyle:(NSInteger)style
                withDelegate:(id)delegate {
    
    SEL sel = @selector(notificationClicked:);
    
    if(![delegate respondsToSelector:sel])
        return;
    
    
    [delegate performSelector:sel
                   withObject:object];
    
}

@end
