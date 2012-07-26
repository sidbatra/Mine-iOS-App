//
//  DWAppDelegate.m
//  Mine
//
//  Created by Siddharth Batra on 7/20/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWAppDelegate.h"

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

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWAppDelegate

@synthesize window                  = _window;
@synthesize tabBarController        = _tabBarController;
@synthesize welcomeNavController    = _welcomeNavController;
@synthesize feedNavController       = _feedNavController;

//----------------------------------------------------------------------------------------------------
- (void)setupApplication {
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(welcomeNavigationFinished:) 
                                                 name:kNWelcomeNavigationFinished
                                               object:nil];
    
    [self setupTabBarController];
    
    [self.window addSubview:self.tabBarController.view];
    [self.window makeKeyAndVisible]; 
    
    
    if(![[DWSession sharedDWSession] isAuthenticated])
        [self.tabBarController presentModalViewController:self.welcomeNavController
                                                 animated:NO];
}

//----------------------------------------------------------------------------------------------------
- (void)setupTabBarController {
    
    UIViewController *_b = [[UIViewController alloc] init];
    _b.view.backgroundColor = [UIColor greenColor];
    
    UIViewController *_c = [[UIViewController alloc] init];
    _c.view.backgroundColor = [UIColor blueColor];
    
    
    self.tabBarController = [[DWTabBarController alloc] init];
    self.tabBarController.delegate = self;
    
    [self.tabBarController addSubController:self.feedNavController];
    [self.tabBarController addSubController:_b];
    [self.tabBarController addSubController:_c];
    
    
    self.tabBarController.tabBar.frame = CGRectMake(0, 411, 320, 49);
    
    [self.tabBarController.tabBar addTabWithWidth:114 
                                  normalImageName:@"tab_feed_off.png"
                                selectedImageName:@"tab_feed_on.png"
                             highlightedImageName:nil
                             isMappedToController:YES
                                       isSelected:YES];
    
    [self.tabBarController.tabBar addTabWithWidth:92
                                  normalImageName:@"tab_create_off.png"
                                selectedImageName:@"tab_create_off.png"
                             highlightedImageName:nil
                             isMappedToController:YES
                                       isSelected:NO];
    
    [self.tabBarController.tabBar addTabWithWidth:114
                                  normalImageName:@"tab_teams_off.png"
                                selectedImageName:@"tab_teams_on.png"
                             highlightedImageName:nil
                             isMappedToController:YES
                                       isSelected:NO];
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

- (void)selectedTabModifiedFrom:(NSInteger)oldSelectedIndex 
                             to:(NSInteger)newSelectedIndex {
    
    if(newSelectedIndex == kCreateTabIndex) {
        
    }        
}

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)welcomeNavigationFinished:(NSNotification*)notification {
    DWUser *user = [[notification userInfo] objectForKey:kKeyUser];
    [[DWSession sharedDWSession] create:user];
        
    [self.tabBarController dismissModalViewControllerAnimated:YES];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Application notifications

//----------------------------------------------------------------------------------------------------
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setupApplication];
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

@end
