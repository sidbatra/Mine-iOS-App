//
//  DWUser.m
//  Mine
//
//  Created by Siddharth Batra on 7/20/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWUser.h"
#import "DWImageManager.h"

NSString* const kKeySquareImageURL          = @"square_image_url";
NSString* const kNImgUserSquareLoaded       = @"NImgUserSquareLoaded";
NSString* const kNImgUserSquareLoadError    = @"NImgUserSquareLoadError";
NSString* const kNImgUserLargeLoaded        = @"NImgUserLargeLoaded";
NSString* const kNImgUserLargeLoadError     = @"NImgUserLargeLoadError";



static NSString* const kEncodeKeyID                         = @"DWUser_id";
static NSString* const kEncodeKeyFirstName                  = @"DWUser_firstName";
static NSString* const kEncodeKeyLastName                   = @"DWUser_lastName";
static NSString* const kEncodeKeyGender                     = @"DWUser_gender";
static NSString* const kEncodeKeyHandle                     = @"DWUser_handle";
static NSString* const kEncodeKeyByline                     = @"DWUser_byline";
static NSString* const kEncodeKeyFacebookAccessToken        = @"DWUser_facebookAccessToken";
static NSString* const kEncodeKeyTwitterAccessToken         = @"DWUser_twitterAccessToken";
static NSString* const kEncodeKeyTwitterAccessTokenSecret   = @"DWUser_twitterAccessTokenSecret";
static NSString* const kEncodeKeyTumblrAccessToken          = @"DWUser_tumblrAccessToken";
static NSString* const kEncodeKeyTumblrAccessTokenSecret    = @"DWUser_tumblrAccessTokenSecret";
static NSString* const kEncodeKeySquareImageURL             = @"DWUser_squareImageURL";
static NSString* const kEncodeKeyLargeImageURL              = @"DWUser_largeImageURL";
static NSString* const kEncodeKeyPurchasesCount             = @"DWUser_purchasesCount";
static NSString* const kEncodeKeyFollowingsCount            = @"DWUser_followingsCount";
static NSString* const kEncodeKeyInverseFollowingsCount     = @"DWUser_inverseFollowingsCount";


static NSString* const kKeyFirstName                    = @"first_name";
static NSString* const kKeyLastName                     = @"last_name";
static NSString* const kKeyGender                       = @"gender";
static NSString* const kKeyHandle                       = @"handle";
static NSString* const kKeyByline                       = @"byline";
static NSString* const kKeyFacebookAccessToken          = @"access_token";
static NSString* const kKeyTwitterAccessToken           = @"tw_access_token";
static NSString* const kKeyTwitterAccessTokenSecret     = @"tw_access_token_secret";
static NSString* const kKeyTumblrAccessToken            = @"tumblr_access_token";
static NSString* const kKeyTumblrAccessTokenSecret      = @"tumblr_access_token_secret";
static NSString* const kKeyLargeImageURL                = @"large_image_url";
static NSString* const kKeyPurchasesCount               = @"purchases_count";
static NSString* const kKeyFollowingsCount              = @"followings_count";
static NSString* const kKeyInverseFollowingsCount       = @"inverse_followings_count";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUser
    
@synthesize firstName                   = _firstName;
@synthesize lastName                    = _lastName;
@synthesize gender                      = _gender;
@synthesize handle                      = _handle;
@synthesize byline                      = _byline;
@synthesize facebookAccessToken         = _facebookAccessToken;
@synthesize twitterAccessToken          = _twitterAccessToken;
@synthesize twitterAccessTokenSecret    = _twitterAccessTokenSecret;
@synthesize tumblrAccessToken           = _tumblrAccessToken;
@synthesize tumblrAccessTokenSecret     = _tumblrAccessTokenSecret;
@synthesize squareImageURL          	= _squareImageURL;
@synthesize largeImageURL               = _largeImageURL;
@synthesize purchasesCount              = _purchasesCount;
@synthesize followingsCount             = _followingsCount;
@synthesize inverseFollowingsCount      = _inverseFollowingsCount;

//----------------------------------------------------------------------------------------------------
- (id)initWithCoder:(NSCoder*)coder {
    self = [super init];
    
    if(self) {
        self.databaseID                 = [[coder decodeObjectForKey:kEncodeKeyID] integerValue];
        self.firstName                  = [coder decodeObjectForKey:kEncodeKeyFirstName];
        self.lastName                   = [coder decodeObjectForKey:kEncodeKeyLastName];
        self.gender                     = [coder decodeObjectForKey:kEncodeKeyGender];
        self.handle                     = [coder decodeObjectForKey:kEncodeKeyHandle];
        self.byline                     = [coder decodeObjectForKey:kEncodeKeyByline];

        self.facebookAccessToken        = [coder decodeObjectForKey:kEncodeKeyFacebookAccessToken];
        self.twitterAccessToken         = [coder decodeObjectForKey:kEncodeKeyTwitterAccessToken];
        self.twitterAccessTokenSecret   = [coder decodeObjectForKey:kEncodeKeyTwitterAccessTokenSecret];        
        self.tumblrAccessToken          = [coder decodeObjectForKey:kEncodeKeyTumblrAccessToken];
        self.tumblrAccessTokenSecret    = [coder decodeObjectForKey:kEncodeKeyTumblrAccessTokenSecret];        
        
        self.squareImageURL             = [coder decodeObjectForKey:kEncodeKeySquareImageURL];
        self.largeImageURL              = [coder decodeObjectForKey:kEncodeKeyLargeImageURL];
        
        self.purchasesCount             = [[coder decodeObjectForKey:kEncodeKeyPurchasesCount] integerValue];
        self.followingsCount            = [[coder decodeObjectForKey:kEncodeKeyFollowingsCount] integerValue];
        self.inverseFollowingsCount     = [[coder decodeObjectForKey:kEncodeKeyInverseFollowingsCount] integerValue];
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
    [coder encodeObject:self.firstName                                  forKey:kEncodeKeyFirstName];
    [coder encodeObject:self.lastName                                   forKey:kEncodeKeyLastName];
    [coder encodeObject:self.gender                                     forKey:kEncodeKeyGender];
    [coder encodeObject:self.handle                                     forKey:kEncodeKeyHandle];
    [coder encodeObject:self.byline                                     forKey:kEncodeKeyByline];

    [coder encodeObject:self.facebookAccessToken                        forKey:kEncodeKeyFacebookAccessToken];
    [coder encodeObject:self.twitterAccessToken                         forKey:kEncodeKeyTwitterAccessToken];
    [coder encodeObject:self.twitterAccessTokenSecret                   forKey:kEncodeKeyTwitterAccessTokenSecret];    
    [coder encodeObject:self.tumblrAccessToken                          forKey:kEncodeKeyTumblrAccessToken];
    [coder encodeObject:self.tumblrAccessTokenSecret                    forKey:kEncodeKeyTumblrAccessTokenSecret];    
    
    [coder encodeObject:self.squareImageURL                             forKey:kEncodeKeySquareImageURL];
    [coder encodeObject:self.largeImageURL                              forKey:kEncodeKeyLargeImageURL];
    
    [coder encodeObject:[NSNumber numberWithInt:self.purchasesCount]    forKey:kEncodeKeyPurchasesCount];
    [coder encodeObject:[NSNumber numberWithInt:self.followingsCount]    forKey:kEncodeKeyFollowingsCount];
    [coder encodeObject:[NSNumber numberWithInt:self.inverseFollowingsCount]    forKey:kEncodeKeyInverseFollowingsCount];
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
	[self freeMemory];
    
	NSLog(@"User released %d",self.databaseID);
}

//----------------------------------------------------------------------------------------------------
- (void)freeMemory {
    [[DWImageManager sharedDWImageManager] remove:self.squareImageURL];
    [[DWImageManager sharedDWImageManager] remove:self.largeImageURL];
}

//----------------------------------------------------------------------------------------------------
- (void)update:(NSDictionary*)user {
    [super update:user];
	
    NSString *firstName                 = [user objectForKey:kKeyFirstName];
    NSString *lastName                  = [user objectForKey:kKeyLastName];
    NSString *gender                    = [user objectForKey:kKeyGender];
    NSString *handle                    = [user objectForKey:kKeyHandle];
    NSString *byline                    = [user objectForKey:kKeyByline];

    NSString *facebookAccessToken       = [user objectForKey:kKeyFacebookAccessToken];
    NSString *twitterAccessToken        = [user objectForKey:kKeyTwitterAccessToken];
    NSString *twitterAccessTokenSecret  = [user objectForKey:kKeyTwitterAccessTokenSecret];   
    NSString *tumblrAccessToken         = [user objectForKey:kKeyTumblrAccessToken];
    NSString *tumblrAccessTokenSecret   = [user objectForKey:kKeyTumblrAccessTokenSecret];    
    
    NSString *squareImageURL            = [user objectForKey:kKeySquareImageURL];
    NSString *largeImageURL             = [user objectForKey:kKeyLargeImageURL];
    
    NSString *purchasesCount            = [user objectForKey:kKeyPurchasesCount];
    NSString *followingsCount           = [user objectForKey:kKeyFollowingsCount];
    NSString *inverseFollowingsCount    = [user objectForKey:kKeyInverseFollowingsCount];
    
    
    if(firstName && ![firstName isKindOfClass:[NSNull class]] && ![self.firstName isEqualToString:firstName])
        self.firstName = firstName;
    
    if(lastName && ![lastName isKindOfClass:[NSNull class]] && ![self.lastName isEqualToString:lastName])
        self.lastName = lastName;
    
    if(gender && ![gender isKindOfClass:[NSNull class]] && ![self.gender isEqualToString:gender])
        self.gender = gender;
    
    if(handle && ![self.handle isEqualToString:handle])
        self.handle = handle;
    
    if(byline && ![self.byline isEqualToString:byline])
        self.byline = byline;
    
    
    if(facebookAccessToken  && ![facebookAccessToken isKindOfClass:[NSNull class]]  && ![self.facebookAccessToken isEqualToString:facebookAccessToken])
        self.facebookAccessToken = facebookAccessToken;
    
    if(twitterAccessToken  && ![twitterAccessToken isKindOfClass:[NSNull class]] && ![self.twitterAccessToken isEqualToString:twitterAccessToken])
        self.twitterAccessToken = twitterAccessToken;
    
    if(twitterAccessTokenSecret  && ![twitterAccessTokenSecret isKindOfClass:[NSNull class]] && ![self.twitterAccessTokenSecret isEqualToString:twitterAccessTokenSecret])
        self.twitterAccessTokenSecret = twitterAccessTokenSecret;    
    
    if(tumblrAccessToken  && ![tumblrAccessToken isKindOfClass:[NSNull class]] && ![self.tumblrAccessToken isEqualToString:tumblrAccessToken])
        self.tumblrAccessToken = tumblrAccessToken;
    
    if(tumblrAccessTokenSecret  && ![tumblrAccessTokenSecret isKindOfClass:[NSNull class]] && ![self.tumblrAccessTokenSecret isEqualToString:tumblrAccessTokenSecret])
        self.tumblrAccessTokenSecret = tumblrAccessTokenSecret;    

    
    if(squareImageURL && ![self.squareImageURL isEqualToString:squareImageURL])
        self.squareImageURL = squareImageURL;
    
    if(largeImageURL && ![self.largeImageURL isEqualToString:largeImageURL])
        self.largeImageURL = largeImageURL;
    
    
    if(purchasesCount)
        self.purchasesCount = [purchasesCount integerValue];
    
    if(followingsCount)
        self.followingsCount = [followingsCount integerValue];
    
    if(inverseFollowingsCount)
        self.inverseFollowingsCount = [inverseFollowingsCount integerValue];
}

//----------------------------------------------------------------------------------------------------
- (NSString*)fullName {
    return [NSString stringWithFormat:@"%@ %@",self.firstName,self.lastName];
}

//----------------------------------------------------------------------------------------------------
- (UIImage*)squareImage {
    return [[DWImageManager sharedDWImageManager] fetch:self.squareImageURL];
}

//----------------------------------------------------------------------------------------------------
- (UIImage*)largeImage {
    return [[DWImageManager sharedDWImageManager] fetch:self.largeImageURL];
}

//----------------------------------------------------------------------------------------------------
- (void)downloadSquareImage {
    if(!self.squareImageURL)
        return;
    
    [[DWImageManager sharedDWImageManager] downloadImageAtURL:self.squareImageURL
                                               withResourceID:self.databaseID
                                          successNotification:kNImgUserSquareLoaded
                                            errorNotification:kNImgUserSquareLoadError]; 
}

//----------------------------------------------------------------------------------------------------
- (void)downloadLargeImage {
    if(!self.largeImageURL)
        return;
    
    [[DWImageManager sharedDWImageManager] downloadImageAtURL:self.largeImageURL
                                               withResourceID:self.databaseID
                                          successNotification:kNImgUserLargeLoaded
                                            errorNotification:kNImgUserLargeLoadError];
}

//----------------------------------------------------------------------------------------------------
- (BOOL)isTwitterAuthorized {
    return self.twitterAccessToken && self.twitterAccessTokenSecret;
}

//----------------------------------------------------------------------------------------------------
- (BOOL)isTumblrAuthorized {
    return self.tumblrAccessToken && self.tumblrAccessTokenSecret;
}

//----------------------------------------------------------------------------------------------------
- (void)debug {
    NSLog(@"%@ %@ %@ %@ %@  %@  %@ %@  %@ %@  %@ %@  %d %d %d",
          self.firstName,self.lastName,self.gender,self.handle,self.byline,
          self.facebookAccessToken,
          self.twitterAccessToken,self.twitterAccessTokenSecret,          
          self.tumblrAccessToken,self.tumblrAccessTokenSecret,
          self.squareImageURL,self.largeImageURL,
          self.purchasesCount,
          self.followingsCount,
          self.inverseFollowingsCount);
}


@end

