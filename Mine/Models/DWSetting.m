//
//  DWSetting.m
//  Mine
//
//  Created by Siddharth Batra on 8/7/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWSetting.h"

static NSString* const kEncodeKeyID                     = @"DWSetting_id";
static NSString* const kEncodeKeyShareToFacebook        = @"DWSetting_shareToFacebook";
static NSString* const kEncodeKeyShareToTwitter         = @"DWSetting_shareToTwitter";
static NSString* const kEncodeKeyShareToTumblr          = @"DWSetting_shareToTumblr";
static NSString* const kEncodeKeyFBPublishActions       = @"DWSetting_fbPublishActions";

static NSString* const kKeyShareToFacebook              = @"share_to_facebook";
static NSString* const kKeyShareToTwitter               = @"share_to_twitter";
static NSString* const kKeyShareToTumblr                = @"share_to_tumblr";
static NSString* const kKeyFBPublishActions             = @"fb_publish_actions";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWSetting

@synthesize shareToFacebook     = _shareToFacebook;
@synthesize shareToTwitter      = _shareToTwitter;
@synthesize shareToTumblr       = _shareToTumblr;
@synthesize fbPublishActions    = _fbPublishActions;

//----------------------------------------------------------------------------------------------------
- (id)initWithCoder:(NSCoder*)coder {
    self = [super init];
    
    if(self) {
        self.databaseID         = [[coder decodeObjectForKey:kEncodeKeyID] integerValue];
        self.shareToFacebook    = [[coder decodeObjectForKey:kEncodeKeyShareToFacebook] boolValue];
        self.shareToTwitter     = [[coder decodeObjectForKey:kEncodeKeyShareToTwitter] boolValue];
        self.shareToTumblr      = [[coder decodeObjectForKey:kEncodeKeyShareToTumblr] boolValue];
        self.fbPublishActions   = [[coder decodeObjectForKey:kEncodeKeyFBPublishActions] boolValue];
    }
    
    
    if(self.databaseID)
        [self mount];
    else 
        self = nil;
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)encodeWithCoder:(NSCoder*)coder {
    [coder encodeObject:[NSNumber numberWithInt:self.databaseID]    	forKey:kEncodeKeyID];
    [coder encodeObject:[NSNumber numberWithBool:self.shareToFacebook]  forKey:kEncodeKeyShareToFacebook];
    [coder encodeObject:[NSNumber numberWithBool:self.shareToTwitter]   forKey:kEncodeKeyShareToTwitter];
    [coder encodeObject:[NSNumber numberWithBool:self.shareToTumblr]    forKey:kEncodeKeyShareToTumblr];
    [coder encodeObject:[NSNumber numberWithBool:self.fbPublishActions] forKey:kEncodeKeyFBPublishActions];
}

//----------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	
	if(self) {  
    }
	
	return self;  
}

//----------------------------------------------------------------------------------------------------
-(void)dealloc{
	NSLog(@"Setting released %d",self.databaseID);
}

//----------------------------------------------------------------------------------------------------
- (void)update:(NSDictionary*)setting {
    [super update:setting];
	
    NSString *shareToFacebook   = [setting objectForKey:kKeyShareToFacebook];
    NSString *shareToTwitter    = [setting objectForKey:kKeyShareToTwitter];
    NSString *shareToTumblr     = [setting objectForKey:kKeyShareToTumblr];
    NSString *fbPublishActions  = [setting objectForKey:kKeyFBPublishActions];
    
    if(shareToFacebook)
        self.shareToFacebook = [shareToFacebook boolValue];
    
    if(shareToTwitter)
        self.shareToTwitter = [shareToTwitter boolValue];
    
    if(shareToTumblr)
        self.shareToTumblr = [shareToTumblr boolValue];
    
    if(fbPublishActions)
        self.fbPublishActions = [fbPublishActions boolValue];
}

//----------------------------------------------------------------------------------------------------
- (void)debug {
    NSLog(@"%d %d %d %d %d",self.databaseID,self.shareToFacebook,self.shareToTwitter,self.shareToTumblr,self.fbPublishActions);
}

@end


