//
//  DWShareProfileViewController.m
//  Mine
//
//  Created by Siddharth Batra on 1/7/13.
//  Copyright (c) 2013 Denwen, Inc. All rights reserved.
//

#import "DWShareProfileViewController.h"

#import "DWGUIManager.h"
#import "DWAnalyticsManager.h"
#import "DWSession.h"
#import "DWConstants.h"

#import <Social/SLComposeViewController.h>
#import <Social/SLServiceTypes.h>
#import <Twitter/TWTweetComposeViewController.h>


@interface DWShareProfileViewController ()

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWShareProfileViewController

@synthesize facebookButton = _facebookButton;
@synthesize twitterButton = _twitterButton;
@synthesize mainMessageLabel = _mainMessageLabel;
@synthesize bottomMessageLabel = _bottomMessageLabel;
@synthesize isOnboarding = _isOnboarding;
@synthesize delegate = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    
    self = [super init];
    
    if (self) {
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
}

//----------------------------------------------------------------------------------------------------
- (BOOL)isFacebookConnectAvailable {
    return SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0") && [SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook];
}

//----------------------------------------------------------------------------------------------------
- (BOOL)isTwitterConnectAvailable {
    return [TWTweetComposeViewController canSendTweet];
}

//----------------------------------------------------------------------------------------------------
- (BOOL)isAnyConnectAvailable {
    return self.isTwitterConnectAvailable || self.isFacebookConnectAvailable;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark View lifecycle

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.titleView  = [DWGUIManager navBarTitleViewWithText:(self.isOnboarding ? @"3. Success" : @"You're all set")];
    self.navigationItem.rightBarButtonItem = [DWGUIManager navBarDoneButtonWithTarget:self];
    
    CGRect sourceFrame = self.twitterButton.frame;
    
    if(!self.isFacebookConnectAvailable) {
        self.facebookButton.hidden = YES;
        self.twitterButton.frame = self.facebookButton.frame;
        sourceFrame = self.twitterButton.frame;
    }
    else if(!self.isTwitterConnectAvailable) {
        self.twitterButton.hidden = YES;
        sourceFrame = self.facebookButton.frame;
    }
    
    CGRect frame = self.bottomMessageLabel.frame;
    frame.origin.y = sourceFrame.origin.y  + sourceFrame.size.height + 10;
    self.bottomMessageLabel.frame = frame;
    
    if(!self.isOnboarding)
        self.mainMessageLabel.text = @"Your Mine is up to date.";
    
    if(self.isOnboarding)
        [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Welcome Share View"];
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Share Profile View"];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UI events

//----------------------------------------------------------------------------------------------------
- (IBAction)facebookButtonClicked:(id)sender {
    
    SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
        switch(result){
            case SLComposeViewControllerResultCancelled:
            default:
            {
                [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Profile Not Shared to FB"];
                
            }
            break;
            case SLComposeViewControllerResultDone:
            {
                [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Profile Shared to FB"];
            }
            break;
        }};
    
    NSString *url = [NSString stringWithFormat:@"http://%@/%@",kAppServer,[DWSession sharedDWSession].currentUser.handle];
    
    NSString *baseText = self.isOnboarding ? @"Some things I've bought recently"  : @"My Mine has a few new items";
    
    SLComposeViewController *facebookView  = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    facebookView.completionHandler = completionHandler;
    [facebookView setInitialText:[NSString stringWithFormat:@"%@ %@",baseText,url]];
    [facebookView addURL:[NSURL URLWithString:url]];
    
    [self.navigationController presentModalViewController:facebookView animated:YES];
}

//----------------------------------------------------------------------------------------------------
- (IBAction)twitterButtonClicked:(id)sender {
    TWTweetComposeViewController *tweetView = [[TWTweetComposeViewController alloc] init];
    
    tweetView.completionHandler = ^(SLComposeViewControllerResult result) {
        switch(result) {
            case SLComposeViewControllerResultCancelled:
                [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Profile Not Shared to TW"];
                break;
            case SLComposeViewControllerResultDone:
                [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Profile Shared to TW"];
                break;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController dismissModalViewControllerAnimated:YES];
        });
    };
    
    NSString *baseText = self.isOnboarding ? @"Some things I've bought recently:"  : @"Added a few new items to my Mine:";
    [tweetView setInitialText:[NSString stringWithFormat:@"%@ http://getmine.com/%@",baseText,[DWSession sharedDWSession].currentUser.handle]];
    [self.navigationController presentModalViewController:tweetView animated:YES];
}

//----------------------------------------------------------------------------------------------------
- (void)doneButtonClicked {
    [self.delegate shareProfileViewControllerFinished];
}

@end
