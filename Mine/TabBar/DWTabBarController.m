//
//  DWTabBarController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTabBarController.h"
#import "DWConstants.h"

#define kApplicationFrame	CGRectMake(0,20,320,460)
#define kFullScreenFrame	CGRectMake(0,0,320,460)

//static NSString* const kImgTopShadow        = @"shadow_top.png";
//static NSString* const kImgBottomShadow     = @"shadow_bottom.png";


/**
 * Declarations for private methods and properties
 */
@interface DWTabBarController() {
    //UIImageView         *_topShadowView;
    //UIImageView         *_backgroundView;
	NSMutableArray      *_subControllers;
}

/**
 * Image view with a shadow just below the navigation bar
 */
//@property (nonatomic) UIImageView *topShadowView;

/**
 * Image view for background used throughout the logged in mode
 */
//@property (nonatomic) UIImageView *backgroundView;

/**
 * Controllers added to the tab bar 
 */
@property (nonatomic,strong) NSMutableArray *subControllers;


/**
 * Add the controller's view at the given index from view heirarchy.
 */
- (void)addViewAtIndex:(NSInteger)index;

/**
 * Remove the controller's view at the given index from view heirarchy.
 */
- (void)removeViewAtIndex:(NSInteger)index;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTabBarController

@synthesize tabBar                  = _tabBar;
//@synthesize topShadowView           = _topShadowView;
//@synthesize backgroundView          = _backgroundView;
@synthesize subControllers          = _subControllers;
@synthesize delegate                = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	
	if(self) {
		
		self.tabBar                     = [[DWTabBar alloc] init];
        self.tabBar.delegate            = self;
        
        self.subControllers             = [NSMutableArray array];
        
        /*
        self.topShadowView              = [[UIImageView alloc] initWithImage:
                                            [UIImage imageNamed:kImgTopShadow]];
        self.topShadowView.frame        = CGRectMake(0,44,320,5);
        */
        
        //self.backgroundView             = [DWGUIManager backgroundImageViewWithFrame:kFullScreenFrame];
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
	//[self.view addSubview:self.topShadowView];
    
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

/*
//----------------------------------------------------------------------------------------------------
- (void)resetFrame {
	self.view.frame = kApplicationFrame;
}
 */

//----------------------------------------------------------------------------------------------------
- (void)addViewAtIndex:(NSInteger)index {
	
	UIViewController *controller = [self.subControllers objectAtIndex:index];
    controller.view.frame = CGRectMake(0,0,self.view.frame.size.width,460-self.tabBar.frame.size.height);
	
    [self.view addSubview:controller.view];

	//[self.view insertSubview:controller.view 
    //            belowSubview:self.topShadowView];
}

//----------------------------------------------------------------------------------------------------
- (void)removeViewAtIndex:(NSInteger)index {
	[((UIViewController*)[self.subControllers objectAtIndex:index]).view removeFromSuperview];
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
    
    self.selectedController.view.frame = kFullScreenFrame;
}

//----------------------------------------------------------------------------------------------------
- (void)disableFullScreen {
	self.tabBar.hidden = NO;
    
    self.selectedController.view.frame = CGRectMake(0,0,self.view.frame.size.width,460-self.tabBar.frame.size.height);
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

/*
 //----------------------------------------------------------------------------------------------------
 - (void)hideTopShadowView {
 self.topShadowView.hidden = YES;
 }
 
 //----------------------------------------------------------------------------------------------------
 - (void)showTopShadowView {
 self.topShadowView.hidden = NO;
 }
 */


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWTabBarDelegate

//----------------------------------------------------------------------------------------------------
- (void)selectedTabWithSpecialTab:(BOOL)isSpecial
					 modifiedFrom:(NSInteger)oldSelectedIndex 
							   to:(NSInteger)newSelectedIndex 
                    withResetType:(NSInteger)resetType {
    
	if(!isSpecial) {
		[self removeViewAtIndex:oldSelectedIndex];
		[self addViewAtIndex:newSelectedIndex];
	}
    
    /*
    if(resetType == kResetSoft) {
        [(UINavigationController*)[self getSelectedController] popToRootViewControllerAnimated:YES];
    }
    else if(resetType == kResetHard) {
        UINavigationController *selectedController = (UINavigationController*)[self getSelectedController];
        [selectedController popToRootViewControllerAnimated:NO]; 
       
        if([[selectedController topViewController] respondsToSelector:@selector(scrollToTop)])
            [[selectedController topViewController] performSelector:@selector(scrollToTop)];
    }
	
	[_delegate selectedTabModifiedFrom:oldSelectedIndex
									to:newSelectedIndex];
    
    if(!isSpecial)
        [[NSNotificationCenter defaultCenter] postNotificationName:kNTabSelectionChanged
															object:nil
														  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
																	[NSNumber numberWithInt:oldSelectedIndex],kKeyOldSelectedIndex,
																	[NSNumber numberWithInt:newSelectedIndex],kKeySelectedIndex,
																	nil]];
     */
}


@end
