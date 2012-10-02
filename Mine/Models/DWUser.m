//
//  DWUser.m
//  Mine
//
//  Created by Siddharth Batra on 7/20/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWUser.h"
#import "DWSetting.h"
#import "DWImageManager.h"
#import "DWConstants.h"

NSString* const kKeySquareImageURL          = @"square_image_url";
NSString* const kKeyLargeUserImageURL       = @"large_image_url";
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
static NSString* const kEncodeKeyEmail                      = @"DWUser_email";
static NSString* const kEncodeKeyiphoneDeviceToken          = @"DWUser_iphoneDeviceToken";
static NSString* const kEncodeKeyFacebookAccessToken        = @"DWUser_facebookAccessToken";
static NSString* const kEncodeKeyTwitterAccessToken         = @"DWUser_twitterAccessToken";
static NSString* const kEncodeKeyTwitterAccessTokenSecret   = @"DWUser_twitterAccessTokenSecret";
static NSString* const kEncodeKeyTumblrAccessToken          = @"DWUser_tumblrAccessToken";
static NSString* const kEncodeKeyTumblrAccessTokenSecret    = @"DWUser_tumblrAccessTokenSecret";
static NSString* const kEncodeKeySquareImageURL             = @"DWUser_squareImageURL";
static NSString* const kEncodeKeyLargeImageURL              = @"DWUser_largeImageURL";
static NSString* const kEncodeKeyAge                        = @"DWUser_age";
static NSString* const kEncodeKeyPurchasesCount             = @"DWUser_purchasesCount";
static NSString* const kEncodeKeyFollowingsCount            = @"DWUser_followingsCount";
static NSString* const kEncodeKeyInverseFollowingsCount     = @"DWUser_inverseFollowingsCount";
static NSString* const kEncodeKeySetting                    = @"DWUser_setting";



static NSString* const kKeyFirstName                    = @"first_name";
static NSString* const kKeyLastName                     = @"last_name";
static NSString* const kKeyGender                       = @"gender";
static NSString* const kKeyHandle                       = @"handle";
static NSString* const kKeyByline                       = @"byline";
static NSString* const kKeyEmail                        = @"email";
static NSString* const kKeyiphoneDeviceToken            = @"iphone_device_token";
static NSString* const kKeyFacebookAccessToken          = @"access_token";
static NSString* const kKeyTwitterAccessToken           = @"tw_access_token";
static NSString* const kKeyTwitterAccessTokenSecret     = @"tw_access_token_secret";
static NSString* const kKeyTumblrAccessToken            = @"tumblr_access_token";
static NSString* const kKeyTumblrAccessTokenSecret      = @"tumblr_access_token_secret";
static NSString* const kKeyAge                          = @"age";
static NSString* const kKeyPurchasesCount               = @"purchases_count";
static NSString* const kKeyFollowingsCount              = @"followings_count";
static NSString* const kKeyInverseFollowingsCount       = @"inverse_followings_count";
static NSString* const kKeySensitive                    = @"sensitive";
static NSString* const kKeySetting                      = @"setting";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUser
    
@synthesize firstName                   = _firstName;
@synthesize lastName                    = _lastName;
@synthesize gender                      = _gender;
@synthesize handle                      = _handle;
@synthesize byline                      = _byline;
@synthesize email                       = _email;
@synthesize iphoneDeviceToken           = _iphoneDeviceToken;
@synthesize facebookAccessToken         = _facebookAccessToken;
@synthesize twitterAccessToken          = _twitterAccessToken;
@synthesize twitterAccessTokenSecret    = _twitterAccessTokenSecret;
@synthesize tumblrAccessToken           = _tumblrAccessToken;
@synthesize tumblrAccessTokenSecret     = _tumblrAccessTokenSecret;
@synthesize squareImageURL          	= _squareImageURL;
@synthesize largeImageURL               = _largeImageURL;
@synthesize age                         = _age;
@synthesize purchasesCount              = _purchasesCount;
@synthesize followingsCount             = _followingsCount;
@synthesize inverseFollowingsCount      = _inverseFollowingsCount;
@synthesize setting                     = _setting;

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
        self.email                      = [coder decodeObjectForKey:kEncodeKeyEmail];
        self.iphoneDeviceToken          = [coder decodeObjectForKey:kEncodeKeyiphoneDeviceToken];

        self.facebookAccessToken        = [coder decodeObjectForKey:kEncodeKeyFacebookAccessToken];
        self.twitterAccessToken         = [coder decodeObjectForKey:kEncodeKeyTwitterAccessToken];
        self.twitterAccessTokenSecret   = [coder decodeObjectForKey:kEncodeKeyTwitterAccessTokenSecret];        
        self.tumblrAccessToken          = [coder decodeObjectForKey:kEncodeKeyTumblrAccessToken];
        self.tumblrAccessTokenSecret    = [coder decodeObjectForKey:kEncodeKeyTumblrAccessTokenSecret];        
        
        self.squareImageURL             = [coder decodeObjectForKey:kEncodeKeySquareImageURL];
        self.largeImageURL              = [coder decodeObjectForKey:kEncodeKeyLargeImageURL];
        
        self.age                        = [[coder decodeObjectForKey:kEncodeKeyAge] integerValue];
        self.purchasesCount             = [[coder decodeObjectForKey:kEncodeKeyPurchasesCount] integerValue];
        self.followingsCount            = [[coder decodeObjectForKey:kEncodeKeyFollowingsCount] integerValue];
        self.inverseFollowingsCount     = [[coder decodeObjectForKey:kEncodeKeyInverseFollowingsCount] integerValue];
        
        self.setting                    = [coder decodeObjectForKey:kEncodeKeySetting];
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
    [coder encodeObject:self.email                                      forKey:kEncodeKeyEmail];
    [coder encodeObject:self.iphoneDeviceToken                          forKey:kEncodeKeyiphoneDeviceToken];

    [coder encodeObject:self.facebookAccessToken                        forKey:kEncodeKeyFacebookAccessToken];
    [coder encodeObject:self.twitterAccessToken                         forKey:kEncodeKeyTwitterAccessToken];
    [coder encodeObject:self.twitterAccessTokenSecret                   forKey:kEncodeKeyTwitterAccessTokenSecret];    
    [coder encodeObject:self.tumblrAccessToken                          forKey:kEncodeKeyTumblrAccessToken];
    [coder encodeObject:self.tumblrAccessTokenSecret                    forKey:kEncodeKeyTumblrAccessTokenSecret];    
    
    [coder encodeObject:self.squareImageURL                             forKey:kEncodeKeySquareImageURL];
    [coder encodeObject:self.largeImageURL                              forKey:kEncodeKeyLargeImageURL];
    
    [coder encodeObject:[NSNumber numberWithInt:self.age]               forKey:kEncodeKeyAge];
    [coder encodeObject:[NSNumber numberWithInt:self.purchasesCount]    forKey:kEncodeKeyPurchasesCount];
    [coder encodeObject:[NSNumber numberWithInt:self.followingsCount]    forKey:kEncodeKeyFollowingsCount];
    [coder encodeObject:[NSNumber numberWithInt:self.inverseFollowingsCount]    forKey:kEncodeKeyInverseFollowingsCount];
    
    [coder encodeObject:self.setting                                    forKey:kEncodeKeySetting];
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
    
    [self.setting destroy];
    
	DWDebug(@"User released %d",self.databaseID);
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
    NSString *email                     = [user objectForKey:kKeyEmail];
    NSString *iphoneDeviceToken         = [user objectForKey:kKeyiphoneDeviceToken];

    NSString *facebookAccessToken       = [user objectForKey:kKeyFacebookAccessToken];
    NSString *twitterAccessToken        = [user objectForKey:kKeyTwitterAccessToken];
    NSString *twitterAccessTokenSecret  = [user objectForKey:kKeyTwitterAccessTokenSecret];   
    NSString *tumblrAccessToken         = [user objectForKey:kKeyTumblrAccessToken];
    NSString *tumblrAccessTokenSecret   = [user objectForKey:kKeyTumblrAccessTokenSecret];    
    
    NSString *squareImageURL            = [user objectForKey:kKeySquareImageURL];
    NSString *largeImageURL             = [user objectForKey:kKeyLargeUserImageURL];
    
    NSString *age                       = [user objectForKey:kKeyAge];
    NSString *purchasesCount            = [user objectForKey:kKeyPurchasesCount];
    NSString *followingsCount           = [user objectForKey:kKeyFollowingsCount];
    NSString *inverseFollowingsCount    = [user objectForKey:kKeyInverseFollowingsCount];
    
    NSString *sensitive                 = [user objectForKey:kKeySensitive];
    
    NSDictionary *setting               = [user objectForKey:kKeySetting];
    
    
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
    
    if(email && ![email isKindOfClass:[NSNull class]] && ![self.email isEqualToString:email])
        self.email = email;
    
    if(iphoneDeviceToken && ![iphoneDeviceToken isKindOfClass:[NSNull class]] && ![self.iphoneDeviceToken isEqualToString:iphoneDeviceToken])
        self.iphoneDeviceToken = iphoneDeviceToken;
    

    if(sensitive) {
        self.facebookAccessToken = facebookAccessToken;
        self.twitterAccessToken = twitterAccessToken;
        self.twitterAccessTokenSecret = twitterAccessTokenSecret;
        self.tumblrAccessToken = tumblrAccessToken;
        self.tumblrAccessTokenSecret = tumblrAccessTokenSecret;    
    }
    
    
    if(squareImageURL && ![self.squareImageURL isEqualToString:squareImageURL])
        self.squareImageURL = squareImageURL;
    
    if(largeImageURL && ![self.largeImageURL isEqualToString:largeImageURL])
        self.largeImageURL = largeImageURL;
    
    
    if(age)
        self.age = [age integerValue];
    
    if(purchasesCount)
        self.purchasesCount = [purchasesCount integerValue];
    
    if(followingsCount)
        self.followingsCount = [followingsCount integerValue];
    
    if(inverseFollowingsCount)
        self.inverseFollowingsCount = [inverseFollowingsCount integerValue];
    
    
    if(setting) {
        if(self.setting)
            [self.setting update:setting];
        else
            self.setting = [DWSetting create:setting];;
    }
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
- (BOOL)isFacebookAuthorized {
    return self.facebookAccessToken && self.facebookAccessToken != (id)[NSNull null];
}

//----------------------------------------------------------------------------------------------------
- (BOOL)isTwitterAuthorized {
    return self.twitterAccessToken && self.twitterAccessToken != (id)[NSNull null] &&
            self.twitterAccessTokenSecret && self.twitterAccessTokenSecret != (id)[NSNull null];
}

//----------------------------------------------------------------------------------------------------
- (BOOL)isTumblrAuthorized {
    return self.tumblrAccessToken && self.tumblrAccessToken != (id)[NSNull null] &&
            self.tumblrAccessTokenSecret && self.tumblrAccessTokenSecret != (id)[NSNull null];
}

//----------------------------------------------------------------------------------------------------
- (NSString*)pronoun {
    return [self.gender isEqualToString:@"female"] ? @"her" : @"his";
}

//----------------------------------------------------------------------------------------------------
- (void)debug {
    DWDebug(@"%@ %@ %@ %@ %@ %@ %d %@  %@ %@  %@ %@  %@ %@  %d %d %d %@",
          self.firstName,self.lastName,self.gender,self.handle,self.byline,self.email,self.age,
          self.facebookAccessToken,
          self.twitterAccessToken,self.twitterAccessTokenSecret,          
          self.tumblrAccessToken,self.tumblrAccessTokenSecret,
          self.squareImageURL,self.largeImageURL,
          self.purchasesCount,
          self.followingsCount,
          self.inverseFollowingsCount,
          self.iphoneDeviceToken);
    
    [self.setting debug];
}


@end

