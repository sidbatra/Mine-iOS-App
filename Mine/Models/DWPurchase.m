//
//  DWPurchase.m
//  Mine
//
//  Created by Siddharth Batra on 7/21/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWPurchase.h"

#import "DWImageManager.h"
#import "DWConstants.h"

NSString* const kNImgPurchaseGiantLoaded    = @"NImgPurchaseGiantLoaded";
NSString* const kNImgPurchaseGiantLoadError = @"NImgPurchaseGiantLoadError";


static NSString* const kKeyTitle            = @"title";
static NSString* const kKeyEndorsement      = @"endorsement";
static NSString* const kKeySourceURL        = @"source_url";
static NSString* const kKeyGiantImageURL    = @"giant_url";
static NSString* const kKeyFbObjectID       = @"fb_object_id";
static NSString* const kKeyCreatedAt        = @"created_at";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWPurchase

@synthesize title           = _title;
@synthesize endorsement     = _endorsement;
@synthesize sourceURL       = _sourceURL;
@synthesize giantImageURL   = _giantImageURL;
@synthesize fbObjectID      = _fbObjectID;
@synthesize createdAt       = _createdAt;



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
    
	NSLog(@"Purchase released %d",self.databaseID);
}

//----------------------------------------------------------------------------------------------------
- (void)freeMemory {
    [[DWImageManager sharedDWImageManager] remove:self.giantImageURL];
}

//----------------------------------------------------------------------------------------------------
- (void)update:(NSDictionary*)purchase {
    [super update:purchase];
	
    NSString *title         = [purchase objectForKey:kKeyTitle];
    NSString *endorsement   = [purchase objectForKey:kKeyEndorsement];
    NSString *sourceURL     = [purchase objectForKey:kKeySourceURL];
    NSString *giantImageURL = [purchase objectForKey:kKeyGiantImageURL];
    NSString *fbObjectID    = [purchase objectForKey:kKeyFbObjectID];
    
    NSString *createdAt     = [purchase objectForKey:kKeyCreatedAt];
    
    
    if(title && ![self.title isEqualToString:title])
        self.title = title;
    
    if(endorsement && ![self.endorsement isEqualToString:endorsement])
        self.endorsement = endorsement;
    
    if(sourceURL && ![self.sourceURL isEqualToString:sourceURL])
        self.sourceURL = sourceURL;
    
    if(fbObjectID && ![fbObjectID isKindOfClass:[NSNull class]] && ![self.fbObjectID isEqualToString:fbObjectID])
        self.fbObjectID = fbObjectID;
    
    
    if(giantImageURL && ![self.giantImageURL isEqualToString:giantImageURL])
        self.giantImageURL = giantImageURL;
    
    if(createdAt) {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:kRailsDateTimeFormat];

        self.createdAt = [format dateFromString:createdAt];
    }
}


//----------------------------------------------------------------------------------------------------
- (id)giantImage {
    return [[DWImageManager sharedDWImageManager] fetch:self.giantImageURL];
}

//----------------------------------------------------------------------------------------------------
- (void)downloadGiantImage {
    if(!self.giantImageURL)
        return;
    
    [[DWImageManager sharedDWImageManager] downloadImageAtURL:self.giantImageURL
                                               withResourceID:self.databaseID
                                          successNotification:kNImgPurchaseGiantLoaded
                                            errorNotification:kNImgPurchaseGiantLoadError]; 
}

//----------------------------------------------------------------------------------------------------
- (void)debug {
    NSLog(@"%@ %@ %@ %@ %@ %@",self.title,self.endorsement,self.sourceURL,self.giantImageURL,self.fbObjectID,self.createdAt);
}

@end
