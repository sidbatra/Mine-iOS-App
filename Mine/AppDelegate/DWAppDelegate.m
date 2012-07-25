//
//  DWAppDelegate.m
//  Mine
//
//  Created by Siddharth Batra on 7/20/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWAppDelegate.h"
#import "DWConstants.h"

static NSString* const kImgPlacesOn					= @"tab_teams_on.png";
static NSString* const kImgPlacesOff				= @"tab_teams_off.png";
static NSString* const kImgCreateOn					= @"tab_create_off.png";
static NSString* const kImgCreateOff				= @"tab_create_off.png";
static NSString* const kImgFeedOn					= @"tab_feed_on.png";
static NSString* const kImgFeedOff					= @"tab_feed_off.png";


@implementation DWAppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    UIViewController *_a = [[UIViewController alloc] init];
    _a.view.backgroundColor = [UIColor redColor];
    
    UIViewController *_b = [[UIViewController alloc] init];
    _b.view.backgroundColor = [UIColor greenColor];
    
    UIViewController *_c = [[UIViewController alloc] init];
    _c.view.backgroundColor = [UIColor blueColor];
    
    
    self.tabBarController = [[DWTabBarController alloc] init];
    [self.tabBarController addSubController:_a];
    [self.tabBarController addSubController:_b];
    [self.tabBarController addSubController:_c];
    
    
    self.tabBarController.tabBar.frame = CGRectMake(0, 411, 320, 49);
  
    [self.tabBarController.tabBar addTabWithWidth:114 
                                  normalImageName:kImgFeedOff
                                selectedImageName:kImgFeedOn
                             highlightedImageName:nil
                             isMappedToController:YES
                                       isSelected:YES];
    
    [self.tabBarController.tabBar addTabWithWidth:92
                                  normalImageName:kImgCreateOff
                                selectedImageName:kImgCreateOff
                             highlightedImageName:kImgCreateOn
                             isMappedToController:YES
                                       isSelected:NO];
    
    [self.tabBarController.tabBar addTabWithWidth:114
                                  normalImageName:kImgPlacesOff
                                selectedImageName:kImgPlacesOn
                             highlightedImageName:nil
                             isMappedToController:YES
                                       isSelected:NO];
    
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor blackColor];
    [self.window addSubview:self.tabBarController.view];

    [self.window makeKeyAndVisible]; 
    
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNFacebookURLOpened 
                                                        object:url];
    return YES;
}

//----------------------------------------------------------------------------------------------------
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url 
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNFacebookURLOpened 
                                                        object:url];
    return YES;
}

@end
