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
@synthesize bottomMessageLabel = _bottomMessageLabel;
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
    
    self.navigationItem.titleView  = [DWGUIManager navBarTitleViewWithText:@"3. Success"];
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
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Welcome Share"];
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
                NSLog(@"Cancelled.....");
                
            }
            break;
            case SLComposeViewControllerResultDone:
            {
                NSLog(@"Posted....");
            }
            break;
        }};
    
    NSString *url = [NSString stringWithFormat:@"http://%@/%@",kAppServer,[DWSession sharedDWSession].currentUser.handle];
    
    SLComposeViewController *facebookView  = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    facebookView.completionHandler = completionHandler;
    [facebookView setInitialText:[NSString stringWithFormat:@"I just added some new items to my Mine. %@",url]];
    [facebookView addURL:[NSURL URLWithString:url]];
    
    [self.navigationController presentModalViewController:facebookView animated:YES];
}

//----------------------------------------------------------------------------------------------------
- (IBAction)twitterButtonClicked:(id)sender {
    TWTweetComposeViewController *tweetView = [[TWTweetComposeViewController alloc] init];
    
    tweetView.completionHandler = ^(SLComposeViewControllerResult result) {
        switch(result) {
            case SLComposeViewControllerResultCancelled:
                NSLog(@"CANCEL");
                break;
            case SLComposeViewControllerResultDone:
                NSLog(@"DONE");
                break;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController dismissModalViewControllerAnimated:YES];
        });
    };
    
    [tweetView setInitialText:[NSString stringWithFormat:@"I just added some new items to my @getmine profile: http://getmine.com/%@",[DWSession sharedDWSession].currentUser.handle]];
    [self.navigationController presentModalViewController:tweetView animated:YES];
}

//----------------------------------------------------------------------------------------------------
- (void)doneButtonClicked {
    [self.delegate shareProfileViewControllerFinished];
}

@end
