//
//  DWNotification.h
//  Mine
//
//  Created by Siddharth Batra on 10/14/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWPoolObject.h"

@class DWUser;
@class DWPurchase;

extern NSString* const kNImgNotificationLoaded;
extern NSString* const kNImgNotificationLoadError;
extern NSString* const kKeyUnread;



typedef enum {
    DWNotificationIdentifierLike        = 0,
    DWNotificationIdentifierComment     = 1,
    DWNotificationIdentifierFollowing   = 2
} DWNotificationIdentifier;



@interface DWNotification : DWPoolObject {
    NSDate      *_createdAt;
    NSString    *_entity;
    NSString    *_event;
    NSString    *_resourceType;
    NSString    *_imageURL;
    
    DWNotificationIdentifier _identifier;
    BOOL        _unread;
    
    DWUser      *_user;
    DWPurchase  *_purchase;
}

@property (nonatomic,strong) NSDate *createdAt;
@property (nonatomic,strong) NSString *entity;
@property (nonatomic,strong) NSString *event;
@property (nonatomic,strong) NSString *resourceType;
@property (nonatomic,strong) NSString *imageURL;

@property (nonatomic,readonly) UIImage* image;

@property (nonatomic,assign) DWNotificationIdentifier identifier;
@property (nonatomic,assign) BOOL unread;

@property (nonatomic,strong) DWUser *user;
@property (nonatomic,strong) DWPurchase *purchase;

- (void)downloadImage;
- (void)debug;

@end
