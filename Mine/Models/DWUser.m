//
//  DWUser.m
//  Mine
//
//  Created by Siddharth Batra on 7/20/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWUser.h"

static NSString* const kEncodeKeyFirstName  = @"DWUser_firstName";
static NSString* const kEncodeKeyLastName   = @"DWUser_lastName";



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
        //self.databaseID             = [[coder decodeObjectForKey:kDiskKeyID] integerValue];
        self.firstName              = [coder decodeObjectForKey:kEncodeKeyFirstName];
        self.lastName               = [coder decodeObjectForKey:kEncodeKeyLastName];
    }
    
    /*
    if(self.databaseID)
        [self mount];
    else 
        self = nil;
     */
    
    [self attachObservers];
     
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)encodeWithCoder:(NSCoder*)coder {
    
    //[coder encodeObject:[NSNumber numberWithInt:self.databaseID]    	forKey:kDiskKeyID];
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
-(void)dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	//NSLog(@"user released %d",_databaseID);
}

@end
