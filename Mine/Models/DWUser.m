//
//  DWUser.m
//  Mine
//
//  Created by Siddharth Batra on 7/20/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWUser.h"
#import "DWImageManager.h"


NSString* const kNImgUserSquareLoaded       = @"NImgUserSquareLoaded";
NSString* const kNImgUserSquareLoadError    = @"NImgUserSquareLoadError";
NSString* const kNImgUserLargeLoaded        = @"NImgUserLargeLoaded";
NSString* const kNImgUserLargeLoadError     = @"NImgUserLargeLoadError";



static NSString* const kEncodeKeyID             = @"DWUser_id";
static NSString* const kEncodeKeyFirstName      = @"DWUser_firstName";
static NSString* const kEncodeKeyLastName       = @"DWUser_lastName";
static NSString* const kEncodeKeyGender         = @"DWUser_gender";
static NSString* const kEncodeKeyHandle         = @"DWUser_handle";
static NSString* const kEncodeKeyByline         = @"DWUser_byline";
static NSString* const kEncodeKeySquareImageURL = @"DWUser_squareImageURL";
static NSString* const kEncodeKeyLargeImageURL  = @"DWUser_largeImageURL";
static NSString* const kEncodeKeyPurchasesCount = @"DWUser_purchasesCount";

static NSString* const kKeyFirstName        = @"first_name";
static NSString* const kKeyLastName         = @"last_name";
static NSString* const kKeyGender           = @"gender";
static NSString* const kKeyHandle           = @"handle";
static NSString* const kKeyByline           = @"byline";
static NSString* const kKeySquareImageURL   = @"square_image_url";
static NSString* const kKeyLargeImageURL    = @"large_image_url";
static NSString* const kKeyPurchasesCount   = @"purchases_count";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUser

@synthesize firstName       = _firstName;
@synthesize lastName        = _lastName;
@synthesize gender          = _gender;
@synthesize handle          = _handle;
@synthesize byline          = _byline;
@synthesize squareImageURL  = _squareImageURL;
@synthesize largeImageURL   = _largeImageURL;
@synthesize purchasesCount  = _purchasesCount;

//----------------------------------------------------------------------------------------------------
- (id)initWithCoder:(NSCoder*)coder {
    self = [super init];
    
    if(self) {
        self.databaseID     = [[coder decodeObjectForKey:kEncodeKeyID] integerValue];
        self.firstName      = [coder decodeObjectForKey:kEncodeKeyFirstName];
        self.lastName       = [coder decodeObjectForKey:kEncodeKeyLastName];
        self.gender         = [coder decodeObjectForKey:kEncodeKeyGender];
        self.handle         = [coder decodeObjectForKey:kEncodeKeyHandle];
        self.byline         = [coder decodeObjectForKey:kEncodeKeyByline];
        
        self.squareImageURL = [coder decodeObjectForKey:kEncodeKeySquareImageURL];
        self.largeImageURL  = [coder decodeObjectForKey:kEncodeKeyLargeImageURL];
        
        self.purchasesCount = [[coder decodeObjectForKey:kEncodeKeyPurchasesCount] integerValue];
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
    
    [coder encodeObject:self.squareImageURL                             forKey:kEncodeKeySquareImageURL];
    [coder encodeObject:self.largeImageURL                              forKey:kEncodeKeyLargeImageURL];
    
    [coder encodeObject:[NSNumber numberWithInt:self.purchasesCount]    forKey:kEncodeKeyPurchasesCount];
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
    
	NSLog(@"user released %d",self.databaseID);
}

//----------------------------------------------------------------------------------------------------
- (void)freeMemory {
}

//----------------------------------------------------------------------------------------------------
- (void)update:(NSDictionary*)user {
    [super update:user];
	
    NSString *firstName         = [user objectForKey:kKeyFirstName];
    NSString *lastName          = [user objectForKey:kKeyLastName];
    NSString *gender            = [user objectForKey:kKeyGender];
    NSString *handle            = [user objectForKey:kKeyHandle];
    NSString *byline            = [user objectForKey:kKeyByline];
    
    NSString *squareImageURL    = [user objectForKey:kKeySquareImageURL];
    NSString *largeImageURL     = [user objectForKey:kKeyLargeImageURL];
    
    NSString *purchasesCount    = [user objectForKey:kKeyPurchasesCount];
    
    
    if(firstName && ![firstName isKindOfClass:[NSNull class]] && ![self.firstName isEqualToString:firstName])
        self.firstName = firstName;
    
    if(lastName && ![lastName isKindOfClass:[NSNull class]] && ![self.lastName isEqualToString:lastName])
        self.lastName = lastName;
    
    if(gender && ![gender isKindOfClass:[NSNull class]] && ![self.gender isEqualToString:gender])
        self.gender = gender;
    
    if(handle && ![handle isKindOfClass:[NSNull class]] && ![self.handle isEqualToString:handle])
        self.handle = handle;
    
    if(byline && ![byline isKindOfClass:[NSNull class]] && ![self.byline isEqualToString:byline])
        self.byline = byline;
    
    
    if(squareImageURL && ![self.squareImageURL isEqualToString:squareImageURL])
        self.squareImageURL = squareImageURL;
    
    if(largeImageURL && ![self.largeImageURL isEqualToString:largeImageURL])
        self.largeImageURL = largeImageURL;
    
    
    if(purchasesCount)
        self.purchasesCount = [purchasesCount integerValue];
}


//----------------------------------------------------------------------------------------------------
- (id)squareImage {
    return [[DWImageManager sharedDWImageManager] fetch:self.squareImageURL];
}

//----------------------------------------------------------------------------------------------------
- (id)largeImage {
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


@end

