//
//  DWAnalyticsManager.m
//  Mine
//
//  Created by Siddharth Batra on 8/7/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWAnalyticsManager.h"

#import "MixpanelAPI.h"
#import "SynthesizeSingleton.h"

#import "DWConstants.h"


#if ENVIRONMENT == PRODUCTION
    static NSString* const kMixpanepAPIToken = @"fa62882c2098a4fa7fa4bfa58026ebd3";
#else
    static NSString* const kMixpanepAPIToken = @"3cb70685ab21925da073c025797819da";
#endif



@interface DWAnalyticsManager() {

}

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWAnalyticsManager


SYNTHESIZE_SINGLETON_FOR_CLASS(DWAnalyticsManager);

//----------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	
	if(self) {
        [MixpanelAPI sharedAPIWithToken:kMixpanepAPIToken];
	}
	
	return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {	
}

//----------------------------------------------------------------------------------------------------
- (void)track:(NSString*)name withProperties:(NSMutableDictionary*)properties {
    
    if(properties)
        [[MixpanelAPI sharedAPI] track:name properties:properties];
    else
        [[MixpanelAPI sharedAPI] track:name];
}

//----------------------------------------------------------------------------------------------------
- (void)track:(NSString*)name {
    [self track:name withProperties:nil];
}

//----------------------------------------------------------------------------------------------------
- (void)trackUserWithEmail:(NSString*)email 
                   withAge:(NSInteger)integer
                withGender:(NSString*)gender {
    
    MixpanelAPI *mixpanel = [MixpanelAPI sharedAPI];
    
    mixpanel.nameTag = email;
    [mixpanel registerSuperPropertiesOnce:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",integer],@"Age",
                                           gender,@"Gender", nil]];
    
    [mixpanel registerSuperProperties:[NSDictionary dictionaryWithObjectsAndKeys:kVersion,@"Version", nil]];
}

@end
