//
//  DWTwitterIOSConnect.m
//  Mine
//
//  Created by Siddharth Batra on 1/3/13.
//  Copyright (c) 2013 Denwen, Inc. All rights reserved.
//

#import "DWTwitterIOSConnect.h"

#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>
#import "OAuth+Additions.h"
#import "TWAPIManager.h"
#import "TWSignedRequest.h"

@interface DWTwitterIOSConnect() {
    
}

@property (nonatomic, strong) ACAccountStore *accountStore;
@property (nonatomic, strong) TWAPIManager *apiManager;
@property (nonatomic, strong) NSArray *accounts;

@end


@implementation DWTwitterIOSConnect

@synthesize delegate = _delegate;


//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        _accountStore = [[ACAccountStore alloc] init];
        _apiManager = [[TWAPIManager alloc] init];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)seekPermission {

    [self obtainAccessToAccountsWithBlock:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                
                if(self.accounts.count) {
                    [self.delegate twitterIOSPermissionGranted];
                }
                else {
                    [self.delegate twitterIOSNoAccountsFound];
                }
                
                NSLog(@"permission granted %d",self.accounts.count);
            }
            else {
                [self.delegate twitterIOSPermissionDenied];
                NSLog(@"You were not granted access to the Twitter accounts.");
            }
        });
    }];
}

//----------------------------------------------------------------------------------------------------
- (void)startReverseAuth:(UIView*)targetView {
    
    if (![TWAPIManager isLocalTwitterAccountAvailable])
        return;
    
    if(self.accounts.count == 1) {
        [self performReverseAuthWithAccount:self.accounts[0]];
    }
    else {
        UIActionSheet *sheet = [[UIActionSheet alloc]
                                initWithTitle:@"Select an Account"
                                delegate:self
                                cancelButtonTitle:nil
                                destructiveButtonTitle:nil
                                otherButtonTitles:nil];
        
        for (ACAccount *acct in self.accounts) {
            [sheet addButtonWithTitle:acct.username];
        }
        
        [sheet addButtonWithTitle:@"Cancel"];
        [sheet setDestructiveButtonIndex:[self.accounts count]];
        [sheet showInView:targetView];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)performReverseAuthWithAccount:(ACAccount*)account {
    [_apiManager
     performReverseAuthForAccount:account
     withHandler:^(NSData *responseData, NSError *error) {
         if (responseData) {
             NSString *responseStr = [[NSString alloc]
                                      initWithData:responseData
                                      encoding:NSUTF8StringEncoding];
             
             NSLog(@"%@",responseStr);
             
             NSArray *parts = [responseStr
                               componentsSeparatedByString:@"&"];
             
             NSString *lined = [parts componentsJoinedByString:@"\n"];
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 UIAlertView *alert = [[UIAlertView alloc]
                                       initWithTitle:@"Success!"
                                       message:lined
                                       delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
                 [alert show];
             });
         }
         else {
             NSLog(@"Error!\n%@", [error localizedDescription]);
         }
     }];
}

//----------------------------------------------------------------------------------------------------
- (void)obtainAccessToAccountsWithBlock:(void (^)(BOOL))block {
    ACAccountType *twitterType = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    ACAccountStoreRequestAccessCompletionHandler handler =
    ^(BOOL granted, NSError *error) {
        if (granted) {
            self.accounts = [_accountStore accountsWithAccountType:twitterType];
        }
        
        block(granted);
    };
    
    //iOS 6 check.
    //
    if ([_accountStore
         respondsToSelector:@selector(requestAccessToAccountsWithType:
                                      options:
                                      completion:)]) {
             
             [_accountStore requestAccessToAccountsWithType:twitterType
                                                    options:nil
                                                 completion:handler];
    }
    else {
        [_accountStore requestAccessToAccountsWithType:twitterType
                                 withCompletionHandler:handler];
    }
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UIActionSheetDelegate

//----------------------------------------------------------------------------------------------------
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != (actionSheet.numberOfButtons - 1)) {
        [self performReverseAuthWithAccount:self.accounts[buttonIndex]];
    }
}

@end
