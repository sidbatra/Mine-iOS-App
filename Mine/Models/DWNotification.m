//
//  DWNotification.m
//  Mine
//
//  Created by Siddharth Batra on 10/14/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWNotification.h"
#import "DWImageManager.h"
#import "DWUser.h"
#import "DWPurchase.h"
#import "DWConstants.h"


NSString* const kNImgNotificationLoaded    = @"NImgNotificationLoaded";
NSString* const kNImgNotificationLoadError = @"NImgNotificationLoadError";


static NSString* const kKeyEntity       = @"entity";
static NSString* const kKeyEvent        = @"event";
static NSString* const kKeyResourceType = @"resource_type";
static NSString* const kKeyUnread       = @"unread";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWNotification

@synthesize createdAt       = _createdAt;
@synthesize entity          = _entity;
@synthesize event           = _event;
@synthesize resourceType    = _resourceType;
@synthesize imageURL        = _imageURL;
@synthesize user            = _user;
@synthesize purchase        = _purchase;

//----------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	
	if(self) {
    }
	
	return self;
}

//----------------------------------------------------------------------------------------------------
-(void)dealloc{
	[self freeMemory];
    
    [self.user destroy];
    [self.purchase destroy];
    
	DWDebug(@"Notification released %d",self.databaseID);
}

//----------------------------------------------------------------------------------------------------
- (void)freeMemory {
}

//----------------------------------------------------------------------------------------------------
- (void)update:(NSDictionary*)notification {
    [super update:notification];
    
    
    NSString *createdAt     = [notification objectForKey:kKeyCreatedAt];
    NSString *entity        = [notification objectForKey:kKeyEntity];
    NSString *event         = [notification objectForKey:kKeyEvent];
    NSString *resourceType  = [notification objectForKey:kKeyResourceType];
    NSString *imageURL      = [notification objectForKey:kKeyImageURL];
    NSDictionary *user      = [notification objectForKey:kKeyUser];
    NSDictionary *purchase  = [notification objectForKey:kKeyPurchase];
    
    if(createdAt) {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:kRailsDateTimeFormat];
        
        self.createdAt = [format dateFromString:createdAt];
    }
    
    if(entity && ![self.entity isEqualToString:entity])
        self.entity = entity;
    
    if(event && ![self.event isEqualToString:event])
        self.event = event;
    
    if(resourceType && ![self.resourceType isEqualToString:resourceType])
        self.resourceType = resourceType;
    
    if(imageURL && ![self.imageURL isEqualToString:imageURL])
        self.imageURL = imageURL;

    
    if(user) {
        if(self.user)
            [self.user update:user];
        else
            self.user = [DWUser create:user];
    }
    
    if(purchase) {
        if(self.purchase)
            [self.purchase update:purchase];
        else
            self.purchase = [DWPurchase create:purchase];
    }
}

//----------------------------------------------------------------------------------------------------
- (UIImage*)image {
    return [[DWImageManager sharedDWImageManager] fetch:self.imageURL];
}

//----------------------------------------------------------------------------------------------------
- (void)downloadImage {
    if(!self.imageURL)
        return;
    
    [[DWImageManager sharedDWImageManager] downloadImageAtURL:self.imageURL
                                               withResourceID:self.databaseID
                                          successNotification:kNImgNotificationLoaded
                                            errorNotification:kNImgNotificationLoadError];
}

//----------------------------------------------------------------------------------------------------
- (void)debug {
    DWDebug(@"%d %@ %@ %@ %@ %@",self.databaseID,self.createdAt,self.entity,self.event,self.resourceType,self.imageURL);
    [self.user debug];
    [self.purchase debug];
}

@end
