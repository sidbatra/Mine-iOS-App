//
//  DWTabBarController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTabBarController.h"
#import "DWDevice.h"
#import "DWConstants.h"


/**
 * Declarations for private methods and properties
 */
@interface DWTabBarController() {
    NSMutableArray      *_subControllers;

    UIImageView         *_topShadowView;
    UIImageView         *_bottomShadowView;
    //UIImageView         *_backgroundView;
}

/**
 * Controllers added to the tab bar 
 */
@property (nonatomic,strong) NSMutableArray *subControllers;

/**
 * Image view with a shadow just below the navigation bar
 */
@property (nonatomic,strong) UIImageView *topShadowView;
@property (nonatomic,strong) UIImageView *bottomShadowView;

/**
 * Image view for background used throughout the logged in mode
 */
//@property (nonatomic) UIImageView *backgroundView;


/**
 * Add the controller's view at the given index from view heirarchy.
 */
- (void)addViewAtIndex:(NSInteger)index;

/**
 * Remove the controller's view at the given index from view heirarchy.
 */
- (void)removeViewAtIndex:(NSInteger)index;

/**
 * Returns a CGRect object to be used a frame by all sub controllers.
 */
- (CGRect)subControllerFrame;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTabBarController

@synthesize tabBar                  = _tabBar;
@synthesize subControllers          = _subControllers;
@synthesize delegate                = _delegate;
@synthesize topShadowView           = _topShadowView;
@synthesize bottomShadowView        = _bottomShadowView;
//@synthesize backgroundView          = _backgroundView;


//----------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	
	if(self) {
		
		self.tabBar                     = [[DWTabBar alloc] init];
        self.tabBar.delegate            = self;
        
        self.subControllers             = [NSMutableArray array];
        
        
        self.topShadowView              = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kImgTopShadow]];
        self.topShadowView.frame        = CGRectMake(0,44,320,3);
        
        self.bottomShadowView           = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kImgBottomShadow]];
        self.bottomShadowView.frame     = CGRectMake(0,416-3,320,3);
        /*
        self.backgroundView             = [DWGUIManager backgroundImageViewWithFrame:kFullScreenFrame];
        */
	}
	
	return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self.view addSubview:self.backgroundView];
	[self.view addSubview:self.topShadowView];
    [self.view addSubview:self.bottomShadowView];
    
	[self.view addSubview:self.tabBar];
    
	[self addViewAtIndex:self.tabBar.selectedIndex];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
}

//----------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//----------------------------------------------------------------------------------------------------
- (UIViewController*)selectedController {
	return [self.subControllers objectAtIndex:self.tabBar.selectedIndex];
}

//----------------------------------------------------------------------------------------------------
- (void)addViewAtIndex:(NSInteger)index {
	
	UIViewController *controller = [self.subControllers objectAtIndex:index];
    controller.view.frame = [self subControllerFrame];
	
	[self.view insertSubview:controller.view 
                belowSubview:self.topShadowView];
}

//----------------------------------------------------------------------------------------------------
- (void)removeViewAtIndex:(NSInteger)index {
	[((UIViewController*)[self.subControllers objectAtIndex:index]).view removeFromSuperview];
}

//----------------------------------------------------------------------------------------------------
- (CGRect)subControllerFrame {
    return CGRectMake(0,0,self.view.frame.size.width,[[DWDevice sharedDWDevice] screenHeightMinusStatusBar] - self.tabBar.frame.size.height);
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Public interface

//----------------------------------------------------------------------------------------------------
- (void)addSubController:(UIViewController*)controller {
    [self.subControllers addObject:controller];
}

//----------------------------------------------------------------------------------------------------
- (void)enableFullScreen {
	self.tabBar.hidden = YES;
    self.bottomShadowView.hidden = YES;
    self.selectedController.view.frame = CGRectMake(0,0,[DWDevice sharedDWDevice].screenWidth,[DWDevice sharedDWDevice].screenHeightMinusStatusBar);
}

//----------------------------------------------------------------------------------------------------
- (void)disableFullScreen {
	self.tabBar.hidden = NO;
    self.bottomShadowView.hidden = NO;
    self.selectedController.view.frame = [self subControllerFrame];
}

/*
 //----------------------------------------------------------------------------------------------------
 - (void)highlightTabAtIndex:(NSInteger)index {
 [self.tabBar highlightTabAtIndex:index];
 }
 
 //----------------------------------------------------------------------------------------------------
 - (void)dimTabAtIndex:(NSInteger)index {
 [self.tabBar dimTabAtIndex:index];
 }
 */

 //----------------------------------------------------------------------------------------------------
 - (void)hideTopShadowView {
 self.topShadowView.hidden = YES;
 }
 
 //----------------------------------------------------------------------------------------------------
 - (void)showTopShadowView {
 self.topShadowView.hidden = NO;
 }
 


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWTabBarDelegate

//----------------------------------------------------------------------------------------------------
- (void)selectedTabWithSpecialTab:(BOOL)isSpecial
					 modifiedFrom:(NSInteger)oldSelectedIndex 
							   to:(NSInteger)newSelectedIndex 
                    withResetType:(DWTabBarResetType)resetType {
    
	if(!isSpecial && oldSelectedIndex != newSelectedIndex) {
		[self removeViewAtIndex:oldSelectedIndex];
		[self addViewAtIndex:newSelectedIndex];
	}
    
    if([self.selectedController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = (UINavigationController*)self.selectedController;
 
        if(resetType == DWTabBarResetTypeSoft) {
            [navController popToRootViewControllerAnimated:YES];
        }
        else if(resetType == DWTabBarResetTypeHard) {
            [navController popToRootViewControllerAnimated:NO]; 
       
        
            SEL scrollToTop = @selector(scrollToTop);
            
            if([[navController topViewController] respondsToSelector:scrollToTop])
                [[navController topViewController] performSelector:scrollToTop];
        }
    }
    
	
    SEL tabModified = @selector(selectedTabModifiedFrom:to:);
    
    if([self.delegate respondsToSelector:tabModified])
        [self.delegate selectedTabModifiedFrom:oldSelectedIndex
                                            to:newSelectedIndex];
}


@end
