//
//  DWProduct.m
//  Mine
//
//  Created by Deepak Rao on 7/30/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWProduct.h"
#import "DWImageManager.h"

NSString* const kKeyMediumImageURL              = @"medium_url";
NSString* const kNImgProductMediumLoaded        = @"NImgProductMediumLoaded";
NSString* const kNImgProductMediumLoadError     = @"NImgProductMediumLoadError";
NSString* const kNImgProductLargeLoaded         = @"NImgProductLargeLoaded";
NSString* const kNImgProductLargeLoadError      = @"NImgProductLargeLoadError";


static NSString* const kKeyUniqueID             = @"uniq_id";
static NSString* const kKeyTitle                = @"title";
static NSString* const kKeyLargeImageURL        = @"large_url";
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
    
	NSLog(@"Product released %d",self.databaseID);
}

//----------------------------------------------------------------------------------------------------
- (void)freeMemory {
    [[DWImageManager sharedDWImageManager] remove:self.mediumImageURL];
    [[DWImageManager sharedDWImageManager] remove:self.largeImageURL];    
}

//----------------------------------------------------------------------------------------------------
- (void)update:(NSDictionary*)store {
	
    NSString *uniqueID          = [store objectForKey:kKeyUniqueID];
    NSString *title             = [store objectForKey:kKeyTitle];
    NSString *mediumImageURL    = [store objectForKey:kKeyMediumImageURL];
    NSString *largeImageURL     = [store objectForKey:kKeyLargeImageURL];
    NSString *sourceURL         = [store objectForKey:kKeySourceURL];    
    
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
   NSLog(@"%@ %@ %@ %@ %@",self.uniqueID,self.title,self.mediumImageURL,self.largeImageURL,self.sourceURL);    
}

@end
