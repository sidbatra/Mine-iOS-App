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

static NSString* const kKeyShareToFacebook              = @"share_to_facebook";
static NSString* const kKeyShareToTwitter               = @"share_to_twitter";
static NSString* const kKeyShareToTumblr                = @"share_to_tumblr";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWSetting

@synthesize shareToFacebook     = _shareToFacebook;
@synthesize shareToTwitter      = _shareToTwitter;
@synthesize shareToTumblr       = _shareToTumblr;

//----------------------------------------------------------------------------------------------------
- (id)initWithCoder:(NSCoder*)coder {
    self = [super init];
    
    if(self) {
        self.databaseID         = [[coder decodeObjectForKey:kEncodeKeyID] integerValue];
        self.shareToFacebook    = [[coder decodeObjectForKey:kEncodeKeyShareToFacebook] boolValue];
        self.shareToTwitter     = [[coder decodeObjectForKey:kEncodeKeyShareToTwitter] boolValue];
        self.shareToTumblr      = [[coder decodeObjectForKey:kEncodeKeyShareToTumblr] boolValue];
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
    
    if(shareToFacebook)
        self.shareToFacebook = [shareToFacebook boolValue];
    
    if(shareToTwitter)
        self.shareToTwitter = [shareToTwitter boolValue];
    
    if(shareToTumblr)
        self.shareToTumblr = [shareToTumblr boolValue];
}

//----------------------------------------------------------------------------------------------------
- (void)debug {
    NSLog(@"%d %d %d %d",self.databaseID,self.shareToFacebook,self.shareToTwitter,self.shareToTumblr);
}

@end


