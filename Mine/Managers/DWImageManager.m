//
//  DWImageManager.m
//  Mine
//
//  Created by Siddharth Batra on 7/21/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWImageManager.h"

#import "DWConstants.h"

#import "SynthesizeSingleton.h"


/**
 * Private method and property declarations
 */
@interface DWImageManager()

/**
 * Each key is an image URL and the value is the image object if downloaded
 * and nil if downloading.
 */
@property (nonatomic) NSMutableDictionary *imagePool;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWImageManager

@synthesize imagePool = _imagePool;

SYNTHESIZE_SINGLETON_FOR_CLASS(DWImageManager);

//----------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	
	if(self) {
		self.imagePool = [NSMutableDictionary dictionary];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(imageDownloaded:) 
													 name:kNImageDownloaded
												   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(imageDownloadError:) 
													 name:kNImageDownloadError
												   object:nil];
	}
	
	return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {	
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)imageDownloaded:(NSNotification*)notification {
    
    NSDictionary *info = [notification userInfo];
    NSString *url = [info objectForKey:kKeyURL];
    
    //UIImage *image = [info objectForKey:kKeyImage];
    NSLog(@"DOWNLOADED - %@",url);
}

//----------------------------------------------------------------------------------------------------
- (void)imageDownloadError:(NSNotification*)notification {
    
    NSDictionary *info = [notification userInfo];
    NSString *url = [info objectForKey:kKeyURL];
    
    NSLog(@"ERROR - %@",url);
    //UIImage *image = [info objectForKey:kKeyImage];
}

@end