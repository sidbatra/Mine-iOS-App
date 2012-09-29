//
//  DWSuggestion.m
//  Mine
//
//  Created by Deepak Rao on 8/14/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWSuggestion.h"
#import "DWImageManager.h"
#import "DWConstants.h"

NSString* const kKeyImageURL                    = @"image_url";
NSString* const kKeySmallImageURL               = @"small_image_url";

NSString* const kNImgSuggestionLoaded           = @"NImgSuggestionLoaded";
NSString* const kNImgSuggestionLoadError        = @"NImgSuggestionLoadError";
NSString* const kNImgSuggestionSmallLoaded      = @"NImgSuggestionSmallLoaded";
NSString* const kNImgSuggestionSmallLoadError   = @"NImgSuggestionSmallLoadError";


static NSString* const kKeyTitle                = @"title";
static NSString* const kKeyShortTitle           = @"short_title";
static NSString* const kKeyExample              = @"example";
static NSString* const kKeyThing                = @"thing";


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWSuggestion

@synthesize title               = _title;
@synthesize shortTitle          = _shortTitle;
@synthesize example             = _example;
@synthesize thing               = _thing;

@synthesize imageURL            = _imageURL;
@synthesize smallImageURL       = _smallImageURL;


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
    
	DWDebug(@"Suggestion released %d",self.databaseID);
}

//----------------------------------------------------------------------------------------------------
- (void)freeMemory {
    [[DWImageManager sharedDWImageManager] remove:self.imageURL];
    [[DWImageManager sharedDWImageManager] remove:self.smallImageURL];    
}

//----------------------------------------------------------------------------------------------------
- (void)update:(NSDictionary*)product {
	
    NSString *title             = [product objectForKey:kKeyTitle];
    NSString *shortTitle        = [product objectForKey:kKeyShortTitle];    
    NSString *example           = [product objectForKey:kKeyExample];        
    NSString *thing             = [product objectForKey:kKeyThing];    
    
    NSString *imageURL          = [product objectForKey:kKeyImageURL];
    NSString *smallImageURL     = [product objectForKey:kKeySmallImageURL];
    
        
    if(title && ![self.title isEqualToString:title])
        self.title = title;
    
    if(shortTitle && ![self.shortTitle isEqualToString:shortTitle])
        self.shortTitle = shortTitle;
    
    if(example && ![self.example isEqualToString:example])
        self.example = example;    
    
    if(thing && ![self.thing isEqualToString:thing])
        self.thing = thing;    
    
    if(imageURL && ![self.imageURL isEqualToString:imageURL])
        self.imageURL = imageURL;
    
    if(smallImageURL && ![self.smallImageURL isEqualToString:smallImageURL])
        self.smallImageURL = smallImageURL;
}

//----------------------------------------------------------------------------------------------------
- (UIImage*)image {
    return [[DWImageManager sharedDWImageManager] fetch:self.imageURL];
}

//----------------------------------------------------------------------------------------------------
- (UIImage*)smallImage {
    return [[DWImageManager sharedDWImageManager] fetch:self.smallImageURL];
}

//----------------------------------------------------------------------------------------------------
- (void)downloadImage {
    if(!self.imageURL)
        return;
    
    [[DWImageManager sharedDWImageManager] downloadImageAtURL:self.imageURL
                                               withResourceID:self.databaseID
                                          successNotification:kNImgSuggestionLoaded
                                            errorNotification:kNImgSuggestionLoadError]; 
}

//----------------------------------------------------------------------------------------------------
- (void)downloadSmallImage {
    if(!self.smallImageURL)
        return;
    
    [[DWImageManager sharedDWImageManager] downloadImageAtURL:self.smallImageURL
                                               withResourceID:self.databaseID
                                          successNotification:kNImgSuggestionSmallLoaded
                                            errorNotification:kNImgSuggestionSmallLoadError];
}

//----------------------------------------------------------------------------------------------------
- (void)debug {
    DWDebug(@"%@ %@ %@ %@ %@ %@",self.title,self.shortTitle,self.example,self.thing,self.imageURL,self.smallImageURL);
}

@end
