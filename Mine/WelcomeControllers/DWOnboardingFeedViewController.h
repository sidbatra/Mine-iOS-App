//
//  DWOnboardingFeedViewController.h
//  Mine
//
//  Created by Deepak Rao on 9/13/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DWOnboardingFeedViewControllerDelegate;


@interface DWOnboardingFeedViewController : UIViewController {
    
}

/**
 * Delegate
 */
@property (nonatomic,weak) id<DWOnboardingFeedViewControllerDelegate,NSObject> delegate;

@end


/**
 * Protocol for delegates of DWOnboardingFeedViewController
 */
@protocol DWOnboardingFeedViewControllerDelegate

@optional

/**
 * Fired to show the screen after global feed.
 */
- (void)showScreenAfterGlobalFeed;

@end
