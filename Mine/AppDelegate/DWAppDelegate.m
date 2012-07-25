//
//  DWAppDelegate.m
//  Mine
//
//  Created by Siddharth Batra on 7/20/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWAppDelegate.h"
#import "DWConstants.h"


/**
 * Private declarations
 */
@interface DWAppDelegate() {
    DWTabBarController	*_tabBarController;
}

/**
 * Custom tab bar controller which is the base view added to window.
 */
@property (strong, nonatomic) DWTabBarController *tabBarController;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWAppDelegate

@synthesize window              = _window;
@synthesize tabBarController    = _tabBarController;

//----------------------------------------------------------------------------------------------------
- (void)setupTabBarController {
    
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
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Application notifications

//----------------------------------------------------------------------------------------------------
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self setupTabBarController];
    
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
