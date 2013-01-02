//
//  DWStore.m
//  Mine
//
//  Created by Siddharth Batra on 7/21/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWStore.h"
#import "DWImageManager.h"
#import "DWConstants.h"

NSString* const kNImgStoreMediumLoaded        = @"NImgStoreMediumLoaded";
NSString* const kNImgStoreMediumLoadError     = @"NImgStoreMediumLoadError";

static NSString* const kKeyName = @"name";
static NSString* const kKeyMediumImageURL = @"medium_url";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWStore

@synthesize name     = _name;
@synthesize mediumImageURL = _mediumImageURL;


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
    
	DWDebug(@"Store released %d",self.databaseID);
}

//----------------------------------------------------------------------------------------------------
- (void)freeMemory {
}

//----------------------------------------------------------------------------------------------------
- (void)update:(NSDictionary*)store {
    [super update:store];
	
    NSString *name      = [store objectForKey:kKeyName];
    NSString *mediumImageURL = [store objectForKey:kKeyMediumImageURL];

    if(name && ![self.name isEqualToString:name])
        self.name = name;
        
    if(mediumImageURL && ![self.mediumImageURL isEqualToString:mediumImageURL])
        self.mediumImageURL = mediumImageURL;
}

//----------------------------------------------------------------------------------------------------
- (UIImage*)mediumImage {
    return [[DWImageManager sharedDWImageManager] fetch:self.mediumImageURL];
}

//----------------------------------------------------------------------------------------------------
- (void)downloadMediumImage {
    if(!self.mediumImageURL)
        return;
    
    [[DWImageManager sharedDWImageManager] downloadImageAtURL:self.mediumImageURL
                                               withResourceID:self.databaseID
                                          successNotification:kNImgStoreMediumLoaded
                                            errorNotification:kNImgStoreMediumLoadError];
}


//----------------------------------------------------------------------------------------------------
- (void)debug {
    DWDebug(@"%@ %@",self.name,self.mediumImageURL);
}
@end
