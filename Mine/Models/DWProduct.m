//
//  DWProduct.m
//  Mine
//
//  Created by Deepak Rao on 7/30/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWProduct.h"
#import "DWImageManager.h"
#import "DWConstants.h"

NSString* const kKeyMediumImageURL              = @"medium_url";
NSString* const kKeyLargeImageURL               = @"large_url";
NSString* const kNImgProductMediumLoaded        = @"NImgProductMediumLoaded";
NSString* const kNImgProductMediumLoadError     = @"NImgProductMediumLoadError";
NSString* const kNImgProductLargeLoaded         = @"NImgProductLargeLoaded";
NSString* const kNImgProductLargeLoadError      = @"NImgProductLargeLoadError";

NSString* const kKeyExternalID                  = @"external_id";

static NSString* const kKeyUniqueID             = @"uniq_id";
static NSString* const kKeyTitle                = @"title";
static NSString* const kKeySourceURL            = @"source_url";


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWProduct

@synthesize uniqueID            = _uniqueID;
@synthesize title               = _title;
@synthesize mediumImageURL      = _mediumImageURL;
@synthesize largeImageURL       = _largeImageURL;
@synthesize sourceURL           = _sourceURL;


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
    
	DWDebug(@"Product released %d",self.databaseID);
}

//----------------------------------------------------------------------------------------------------
- (void)freeMemory {
    [[DWImageManager sharedDWImageManager] remove:self.mediumImageURL];
    [[DWImageManager sharedDWImageManager] remove:self.largeImageURL];    
}

//----------------------------------------------------------------------------------------------------
- (void)update:(NSDictionary*)product {
	
    NSString *uniqueID          = [product objectForKey:kKeyUniqueID];
    NSString *title             = [product objectForKey:kKeyTitle];
    NSString *mediumImageURL    = [product objectForKey:kKeyMediumImageURL];
    NSString *largeImageURL     = [product objectForKey:kKeyLargeImageURL];
    NSString *sourceURL         = [product objectForKey:kKeySourceURL];    
    
    if(uniqueID && ![self.uniqueID isEqualToString:uniqueID])
        self.uniqueID = uniqueID;
    
    if(title && ![self.title isEqualToString:title])
        self.title = title;
    
    if(mediumImageURL && ![self.mediumImageURL isEqualToString:mediumImageURL])
        self.mediumImageURL = mediumImageURL;
    
    if(largeImageURL && ![self.largeImageURL isEqualToString:largeImageURL])
        self.largeImageURL = largeImageURL;    
    
    if(sourceURL && ![self.sourceURL isEqualToString:sourceURL])
        self.sourceURL = sourceURL;
}

//----------------------------------------------------------------------------------------------------
- (UIImage*)mediumImage {
    return [[DWImageManager sharedDWImageManager] fetch:self.mediumImageURL];
}

//----------------------------------------------------------------------------------------------------
- (UIImage*)largeImage {
    return [[DWImageManager sharedDWImageManager] fetch:self.largeImageURL];
}

//----------------------------------------------------------------------------------------------------
- (void)downloadMediumImage {
    if(!self.mediumImageURL)
        return;
    
    [[DWImageManager sharedDWImageManager] downloadImageAtURL:self.mediumImageURL
                                               withResourceID:self.databaseID
                                          successNotification:kNImgProductMediumLoaded
                                            errorNotification:kNImgProductMediumLoadError]; 
}

//----------------------------------------------------------------------------------------------------
- (void)downloadLargeImage {
    if(!self.largeImageURL)
        return;
    
    [[DWImageManager sharedDWImageManager] downloadImageAtURL:self.largeImageURL
                                               withResourceID:self.databaseID
                                          successNotification:kNImgProductLargeLoaded
                                            errorNotification:kNImgProductLargeLoadError];
}

//----------------------------------------------------------------------------------------------------
- (void)debug {
   DWDebug(@"%@ %@ %@ %@ %@",self.uniqueID,self.title,self.mediumImageURL,self.largeImageURL,self.sourceURL);    
}

@end
