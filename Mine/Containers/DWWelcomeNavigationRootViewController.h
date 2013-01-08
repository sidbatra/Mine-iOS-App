//
//  DWWelcomeNavigationRootViewController.h
//  Mine
//
//  Created by Siddharth Batra on 7/25/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWNavigationRootViewController.h"

#import "DWLoginViewController.h"
#import "DWSuggestionsViewController.h"
#import "DWEmailConnectViewController.h"
#import "DWOnboardingFeedViewController.h"
#import "DWUserDetailsViewController.h"
#import "DWShareProfileViewController.h"

/**
 * Root view controller for the welcome navigation controller.
 */
@interface DWWelcomeNavigationRootViewController : DWNavigationRootViewController<DWLoginViewControllerDelegate,DWSuggestionsViewControllerDelegate,DWOnboardingFeedViewControllerDelegate,DWUserDetailsViewControllerDelegate,
                                                    DWEmailConnectViewControllerDelegate,DWShareProfileViewControllerDelegate>


@end
