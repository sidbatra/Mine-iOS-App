//
//  DWFeedNavigationViewController.m
//  Mine
//
//  Created by Siddharth Batra on 7/25/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWFeedNavigationViewController.h"
#import "DWFeedViewController.h"
#import "DWUser.h"


@interface DWFeedNavigationViewController () {
    DWFeedViewController *_feedViewController;
}

/**
 * Table view controller for displaying the feed.
 */
@property (nonatomic,strong) DWFeedViewController *feedViewController;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWFeedNavigationViewController

@synthesize feedViewController = _feedViewController;

//----------------------------------------------------------------------------------------------------
- (void)awakeFromNib {
	[super awakeFromNib];	
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark View Lifecycle

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
    
    self.navigationItem.title = @"Feed";
    
    if(!self.feedViewController) {
        self.feedViewController = [[DWFeedViewController alloc] init];
        self.feedViewController.delegate = self;
    }
    
    [self.view addSubview:self.feedViewController.view];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
}



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWFeedViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)feedViewUserClicked:(DWUser *)user {
    [self displayUserProfile:user];
}

//----------------------------------------------------------------------------------------------------
- (void)feedViewAllLikesClickedForPurchase:(DWPurchase *)purchase {
    [self displayAllLikesForPurchase:purchase];
}

//----------------------------------------------------------------------------------------------------
- (void)feedViewCommentClickedForPurchase:(DWPurchase *)purchase 
                       withCreationIntent:(NSNumber *)creationIntent {
    
    [self displayCommentsCreateViewForPurchase:purchase
                            withCreationIntent:[creationIntent boolValue]];
}


@end
