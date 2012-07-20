//
//  DWUser.m
//  Mine
//
//  Created by Siddharth Batra on 7/20/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWUser.h"

static NSString* const kEncodeKeyID         = @"DWUser_id";
static NSString* const kEncodeKeyFirstName  = @"DWUser_firstName";
static NSString* const kEncodeKeyLastName   = @"DWUser_lastName";

static NSString* const kKeyFirstName        = @"first_name";
static NSString* const kKeyLastName         = @"last_name";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUser

@synthesize firstName			= _firstName;
@synthesize lastName			= _lastName;


//----------------------------------------------------------------------------------------------------
- (id)initWithCoder:(NSCoder*)coder {
    self = [super init];
    
    if(self) {
        self.databaseID             = [[coder decodeObjectForKey:kEncodeKeyID] integerValue];
        self.firstName              = [coder decodeObjectForKey:kEncodeKeyFirstName];
        self.lastName               = [coder decodeObjectForKey:kEncodeKeyLastName];
    }
    
    
    if(self.databaseID)
        [self mount];
    else 
        self = nil;
    
    [self attachObservers];
     
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)encodeWithCoder:(NSCoder*)coder {
    
    [coder encodeObject:[NSNumber numberWithInt:self.databaseID]    	forKey:kEncodeKeyID];
    [coder encodeObject:self.firstName                                  forKey:kEncodeKeyFirstName];
    [coder encodeObject:self.lastName                                   forKey:kEncodeKeyLastName];
}

//----------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	
	if(self) {  
        [self attachObservers];
    }
	
	return self;  
}

//----------------------------------------------------------------------------------------------------
-(void)dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	NSLog(@"user released %d",self.databaseID);
}

//----------------------------------------------------------------------------------------------------
- (void)attachObservers {
    
    /*
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(smallImageLoaded:) 
                                                 name:kNImgSmallUserLoaded
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(smallImageError:) 
                                                 name:kNImgSmallUserError
                                               object:nil];
    */
}

//----------------------------------------------------------------------------------------------------
- (void)freeMemory {
}

//----------------------------------------------------------------------------------------------------
- (void)update:(NSDictionary*)user {
    [super update:user];
	
    NSString *firstName = [user objectForKey:kKeyFirstName];
    NSString *lastName  = [user objectForKey:kKeyLastName];
    
    if(firstName && ![firstName isKindOfClass:[NSNull class]] && ![self.firstName isEqualToString:firstName])
        self.firstName = firstName;
    
    if(lastName && ![lastName isKindOfClass:[NSNull class]] && ![self.lastName isEqualToString:lastName])
        self.lastName = lastName;
}



@end
