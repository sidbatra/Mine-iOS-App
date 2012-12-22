//
//  DWHotmailController.m
//  Mine
//
//  Created by Siddharth Batra on 12/21/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWHotmailController.h"

#import "DWRequestManager.h"
#import "NSString+Helpers.h"
#import "DWConstants.h"


static NSString* const kValidateURI = @"/hotmail.json?email=%@&password=%@";


static NSString* const kNValidationLoaded       = @"NValidationLoaded";
static NSString* const kNValidationLoadError    = @"NValidationLoadError";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWHotmailController

@synthesize delegate = _delegate;


//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(validationLoaded:)
													 name:kNValidationLoaded
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(validationLoadError:)
													 name:kNValidationLoadError
												   object:nil];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    DWDebug(@"Hotmail controller released");
}

//----------------------------------------------------------------------------------------------------
- (void)validateEmail:(NSString *)email
          andPassword:(NSString *)password {
    
    NSString *localURL = [NSString stringWithFormat:kValidateURI,
                          [email stringByEncodingHTMLCharacters],
                          [password stringByEncodingHTMLCharacters]];
    
    [[DWRequestManager sharedDWRequestManager] createAppRequest:localURL
                                            successNotification:kNValidationLoaded
                                              errorNotification:kNValidationLoadError
                                                  requestMethod:kPost
                                                   authenticate:YES];
}



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)validationLoaded:(NSNotification*)notification {
    
    SEL sel = @selector(hotmailValidationLoaded:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    NSDictionary *response = [[notification userInfo] objectForKey:kKeyResponse];
    
    
    BOOL status = [[response valueForKey:kKeyStatus] boolValue];
    
    [self.delegate performSelector:sel
                        withObject:[NSNumber numberWithBool:status]];
}

//----------------------------------------------------------------------------------------------------
- (void)validationLoadError:(NSNotification*)notification {
    
    SEL sel = @selector(hotmailValidationLoadError:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    NSError *error = [[notification userInfo] objectForKey:kKeyError];
    
    [self.delegate performSelector:sel
                        withObject:[error localizedDescription]];
}

@end
