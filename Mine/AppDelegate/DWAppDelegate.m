//
//  DWAppDelegate.m
//  Mine
//
//  Created by Siddharth Batra on 7/20/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWAppDelegate.h"

#import "DWNotificationManager.h"
#import "DWFollowingManager.h"
#import "DWSession.h"
#import "DWConstants.h"


static NSString* const kFacebookURLPrefix			= @"fb";
static NSInteger const kCreateTabIndex              = 1;


/**
 * Private declarations
 */
@interface DWAppDelegate() {
    DWTabBarController      *_tabBarController;
}

/**
 * Custom tab bar controller which is the base view added to window.
 */
@property (strong, nonatomic) DWTabBarController *tabBarController;

/**
 * Entry point for the app which sets up the basic structure.
 */
- (void)setupApplication;

/**
 * Creates the tab bar controller and its sub controllers.
 */
- (void)setupTabBarController;

/**
 * Uniform interface for handling requests from external URLs.
 */
- (void)handleExternalURL:(NSURL*)url;

/**
 * Prompt for access to send push notifications.
 */
- (void)registerForPushNotifications;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWAppDelegate

@synthesize window                  = _window;
@synthesize tabBarController        = _tabBarController;
@synthesize welcomeNavController    = _welcomeNavController;
@synthesize feedNavController       = _feedNavController;
@synthesize profileNavController    = _profileNavController;

//----------------------------------------------------------------------------------------------------
- (void)setupApplication {
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(userLoggedIn:) 
                                                 name:kNUserLoggedIn
                                               object:nil];    
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(welcomeNavigationFinished:) 
                                                 name:kNWelcomeNavigationFinished
                                               object:nil];
    
    [self setupTabBarController];
    
    [self.window addSubview:self.tabBarController.view];
    [self.window makeKeyAndVisible]; 
    
    
    [DWFollowingManager sharedDWFollowingManager];
    
    if(![[DWSession sharedDWSession] isAuthenticated])
        [self.tabBarController presentModalViewController:self.welcomeNavController
                                                 animated:NO];
}

//----------------------------------------------------------------------------------------------------
- (void)setupTabBarController {
    
    self.tabBarController = [[DWTabBarController alloc] init];
    self.tabBarController.delegate = self;
    
    [self.tabBarController addSubController:self.feedNavController];
    [self.tabBarController addSubController:[[UIViewController alloc] init]];
    [self.tabBarController addSubController:self.profileNavController];
    
    
    self.tabBarController.tabBar.frame = CGRectMake(0, 406, 320, 44);
    
    [self.tabBarController.tabBar addTabWithWidth:114 
                                  normalImageName:@"tab-left-feed-off.png"
                                selectedImageName:@"tab-left-feed-on.png"
                             highlightedImageName:nil
                             isMappedToController:YES
                                       isSelected:YES];
    
    [self.tabBarController.tabBar addTabWithWidth:92
                                  normalImageName:@"tab-center-add-off.png"
                                selectedImageName:@"tab-center-add-off.png"
                             highlightedImageName:nil
                             isMappedToController:NO
                                       isSelected:NO];
    
    [self.tabBarController.tabBar addTabWithWidth:114
                                  normalImageName:@"tab-right-profile-off.png"
                                selectedImageName:@"tab-right-profile-on.png"
                             highlightedImageName:nil
                             isMappedToController:YES
                                       isSelected:NO];
}

//----------------------------------------------------------------------------------------------------
- (void)registerForPushNotifications {
    
    if(![[DWSession sharedDWSession] isAuthenticated])
        return;
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: UIRemoteNotificationTypeBadge | 
                                                                            UIRemoteNotificationTypeSound | 
                                                                            UIRemoteNotificationTypeAlert];
}

//----------------------------------------------------------------------------------------------------
- (void)handleExternalURL:(NSURL*)url {
    if([[url absoluteString] hasPrefix:kFacebookURLPrefix]) {
       [[NSNotificationCenter defaultCenter] postNotificationName:kNFacebookURLOpened 
                                                           object:url];
    }
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWTabBarControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)selectedTabModifiedFrom:(NSInteger)oldSelectedIndex 
                             to:(NSInteger)newSelectedIndex {
    
    if(newSelectedIndex == kCreateTabIndex) {
        
        DWCreationNavigationViewController *creationRootViewController = [[DWCreationNavigationViewController alloc] init];        
        creationRootViewController.delegate = self;
        
        UINavigationController *creationNavController =  [[UINavigationController alloc] initWithRootViewController:creationRootViewController];

        [self.tabBarController presentModalViewController:creationNavController
                                                 animated:NO];
    }        
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWCreationNavigationViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)dismissCreateView {
    [self.tabBarController dismissModalViewControllerAnimated:YES];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)userLoggedIn:(NSNotification*)notification {
    DWUser *user = [[notification userInfo] objectForKey:kKeyUser];
    [[DWSession sharedDWSession] create:user];
}

//----------------------------------------------------------------------------------------------------
- (void)welcomeNavigationFinished:(NSNotification*)notification {  
    
    [self.tabBarController dismissModalViewControllerAnimated:YES];
    [self registerForPushNotifications];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Application notifications

//----------------------------------------------------------------------------------------------------
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setupApplication];
    [self registerForPushNotifications];
    return YES;
}

//----------------------------------------------------------------------------------------------------
- (void)applicationWillResignActive:(UIApplication *)application {

}

//----------------------------------------------------------------------------------------------------
- (void)applicationDidEnterBackground:(UIApplication *)application {

}

//----------------------------------------------------------------------------------------------------
- (void)applicationWillEnterForeground:(UIApplication *)application {

}

//----------------------------------------------------------------------------------------------------
- (void)applicationDidBecomeActive:(UIApplication *)application {
}

//----------------------------------------------------------------------------------------------------
- (void)applicationWillTerminate:(UIApplication *)application {

}

//----------------------------------------------------------------------------------------------------
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {    

    [self handleExternalURL:url];
    return YES;
}

//----------------------------------------------------------------------------------------------------
- (BOOL)application:(UIApplication*)application 
            openURL:(NSURL*)url 
  sourceApplication:(NSString*)sourceApplication 
         annotation:(id)annotation {
    
    [self handleExternalURL:url];
    return YES;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Push Notification Permission Responses

//----------------------------------------------------------------------------------------------------
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[DWNotificationManager sharedDWNotificationManager] updateDeviceToken:deviceToken];
}

//----------------------------------------------------------------------------------------------------
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
}


@end
