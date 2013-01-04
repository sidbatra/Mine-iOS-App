//
//  DWTwitterIOSConnect.m
//  Mine
//
//  Created by Siddharth Batra on 1/3/13.
//  Copyright (c) 2013 Denwen, Inc. All rights reserved.
//

#import "DWTwitterIOSConnect.h"

#import "DWSession.h"
#import "DWGUIManager.h"

#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>
#import "OAuth+Additions.h"
#import "TWAPIManager.h"
#import "TWSignedRequest.h"

@interface DWTwitterIOSConnect() {
    DWUsersController *_usersController;
    
    BOOL _isAwaitingResponse;
}

@property (nonatomic,strong) DWUsersController *usersController;
@property (nonatomic, strong) ACAccountStore *accountStore;
@property (nonatomic, strong) TWAPIManager *apiManager;
@property (nonatomic, strong) NSArray *accounts;

@end


@implementation DWTwitterIOSConnect

@synthesize usersController = _usersController;
@synthesize updateCurrentUser = _updateCurrentUser;
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
            }
            else {
                [self.delegate twitterIOSPermissionDenied];
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
             
             NSArray *parts = [responseStr
                               componentsSeparatedByString:@"&"];
             
             if(parts.count >= 2) {
                 NSArray *tokenParts = [parts[0] componentsSeparatedByString:@"="];
                 NSArray *secretParts = [parts[1] componentsSeparatedByString:@"="];
                 
                 if([tokenParts[0] isEqualToString:@"oauth_token"] && [secretParts[0] isEqualToString:@"oauth_token_secret"]) {
                     NSString *token = tokenParts[1];
                     NSString *secret = secretParts[1];
                     
                     SEL sel = @selector(twitterIOSSuccessfulWithToken:andSecret:);
                     
                     if([self.delegate respondsToSelector:sel])
                         [self.delegate performSelector:sel
                                             withObject:token
                                             withObject:secret];
                     
                     if(self.updateCurrentUser) {
                         _isAwaitingResponse = YES;
                         
                         self.usersController = [[DWUsersController alloc] init];
                         self.usersController.delegate = self;
                         
                         [self.usersController updateUserHavingID:[DWSession sharedDWSession].currentUser.databaseID
                                                 withTwitterToken:token
                                                 andTwitterSecret:secret];
                     }
                 } //oauth parts
            } //response parts
         }
         else {
             SEL sel = @selector(twitterIOSFailed);
             
             if([self.delegate respondsToSelector:sel])
                 [self.delegate performSelector:sel];
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


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWUsersControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)userUpdated:(DWUser *)user {
    
    if(_isAwaitingResponse) {
        
        SEL sel = @selector(twitterIOSConfigured);
        
        if([self.delegate respondsToSelector:sel])
            [self.delegate performSelector:sel];
        
        _isAwaitingResponse = NO;
    }
    
    [user destroy];
}

//----------------------------------------------------------------------------------------------------
- (void)userUpdateError:(NSString *)error {
    [DWGUIManager connectionErrorAlertView];
}

@end
