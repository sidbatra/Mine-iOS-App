//
//  DWProfileViewController.m
//  Mine
//
//  Created by Siddharth Batra on 7/26/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWProfileViewController.h"
#import "DWProfileViewDataSource.h"
#import "DWUserProfilePresenter.h"
#import "DWPurchaseProfilePresenter.h"
#import "DWPaginationPresenter.h"
#import "DWAnalyticsManager.h"
#import "DWPurchase.h"
#import "DWPagination.h"
#import "DWModelSet.h"
#import "DWUser.h"

#import "DWSession.h"
#import "DWNavigationBarBackButton.h"
#import "DWNavigationBarTitleView.h"
#import "DWConstants.h"

@interface DWProfileViewController() {
    DWFollowButton  *_followButton;
    DWNavigationBarTitleView *_navTitleView;
    
    BOOL _isProfileLoaded;
}

@property (nonatomic,strong) DWFollowButton *followButton;
@property (nonatomic,strong) DWNavigationBarTitleView *navTitleView;
@property (nonatomic,assign) BOOL isProfileLoaded;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWProfileViewController

@synthesize user            = _user;
@synthesize followButton    = _followButton;
@synthesize navTitleView    = _navTitleView;
@synthesize isProfileLoaded = _isProfileLoaded;
@synthesize delegate        = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {        
    
        self.tableViewDataSource = [[DWProfileViewDataSource alloc] init];
        
        [self addModelPresenterForClass:[DWUser class]
                              withStyle:kDefaultModelPresenter 
                          withPresenter:[DWUserProfilePresenter class]];
        
        [self addModelPresenterForClass:[DWModelSet class]
                              withStyle:kDefaultModelPresenter 
                          withPresenter:[DWPurchaseProfilePresenter class]];
        
        [self addModelPresenterForClass:[DWPagination class]
                              withStyle:kDefaultModelPresenter 
                          withPresenter:[DWPaginationPresenter class]];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(purchaseGiantImageLoaded:) 
                                                     name:kNImgPurchaseGiantLoaded
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(userSquareImageLoaded:) 
                                                     name:kNImgUserSquareLoaded
                                                   object:nil];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(requestPurchaseDelete:) 
                                                     name:kNRequestPurchaseDelete
                                                   object:nil];     
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
    
    if(!self.followButton) {
        self.followButton = [[DWFollowButton alloc] initWithFrame:CGRectMake(241, 7, 72, 30) followButtonStyle:kFollowButonStyleDark];
        self.followButton.delegate = self;
        self.followButton.hidden = YES;
    }
    
    if(self.navigationController) {
        
        self.navigationItem.leftBarButtonItem = [DWNavigationBarBackButton backButtonForNavigationController:self.navigationController];
        
        if(!self.navTitleView) {
            self.navTitleView =  [DWNavigationBarTitleView logoTitleView];
        }
    }
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidAppear:(BOOL)animated {
    [self loadProfile];
}

//----------------------------------------------------------------------------------------------------
- (void)applyUser:(DWUser*)user {
    self.user = user;
    ((DWProfileViewDataSource*)self.tableViewDataSource).userID = self.user.databaseID;
}

//----------------------------------------------------------------------------------------------------
- (void)loadProfile {
    if(self.isProfileLoaded)
        return;
    
    self.isProfileLoaded = YES;
    
    
    if(![[DWSession sharedDWSession] isCurrentUser:self.user.databaseID]) {
        self.followButton.hidden = NO;
        [(DWProfileViewDataSource*)self.tableViewDataSource loadFollowing];
    }
    else
        self.followButton.hidden = YES;
    
    [(DWProfileViewDataSource*)self.tableViewDataSource loadUser];
    [(DWProfileViewDataSource*)self.tableViewDataSource loadPurchases];
    
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"User View"];
}



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWPurchaseProfileCell

//----------------------------------------------------------------------------------------------------
- (void)purchaseClicked:(NSInteger)purchaseID {
    
    SEL sel = @selector(profileViewPurchaseClicked:);
    
    if(![self.delegate respondsToSelector:sel])
        return;

    
    DWPurchase *purchase = [DWPurchase fetch:purchaseID];
    
    if(!purchase || purchase.isDestroying)
        return;
    

    [self.delegate performSelector:sel
                        withObject:purchase];
}

//----------------------------------------------------------------------------------------------------
- (void)purchaseURLClicked:(NSInteger)purchaseID {
    
    SEL sel = @selector(profileViewPurchaseURLClicked:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    
    DWPurchase *purchase = [DWPurchase fetch:purchaseID];
    
    if(!purchaseID)
        return;
    
    
    [self.delegate performSelector:sel
                        withObject:purchase]; 
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWProfileViewDataSourceDelegate

//----------------------------------------------------------------------------------------------------
- (void)followingLoadedAndIsActive:(BOOL)isActive {
    
    if(isActive)
        [self.followButton enterActiveState];
    else
        [self.followButton enterInactiveState];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWFollowButtonDelegate

//----------------------------------------------------------------------------------------------------
- (void)followButtonClicked {
    [(DWProfileViewDataSource*)self.tableViewDataSource toggleFollowing];
}



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWUserProfileCellDelegate 

//----------------------------------------------------------------------------------------------------
- (void)followingButtonClicked {
    [self.delegate profileViewFollowingClickedForUser:self.user];
}

//----------------------------------------------------------------------------------------------------
- (void)followersButtonClicked {
    [self.delegate profileViewFollowersClickedForUser:self.user];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)purchaseGiantImageLoaded:(NSNotification*)notification {
    NSDictionary *userInfo = [notification userInfo];
    
    [self provideResourceToVisibleCells:[DWPurchase class] 
                               objectID:[[userInfo objectForKey:kKeyResourceID] integerValue]
                              objectKey:kKeyGiantImageURL];
}

//----------------------------------------------------------------------------------------------------
- (void)userSquareImageLoaded:(NSNotification*)notification {
    NSDictionary *userInfo = [notification userInfo];
    
    [self provideResourceToVisibleCells:[DWUser class] 
                               objectID:[[userInfo objectForKey:kKeyResourceID] integerValue]
                              objectKey:kKeySquareImageURL];
}

//----------------------------------------------------------------------------------------------------
- (void)requestPurchaseDelete:(NSNotification*)notification {
    
    NSDictionary *userInfo  = [notification userInfo];
    DWPurchase *purchase    = [DWPurchase fetch:[[userInfo objectForKey:kKeyResourceID] integerValue]];
    
    if(self.user.databaseID != purchase.user.databaseID)
        return;
    
    [self reloadTableView];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors

//----------------------------------------------------------------------------------------------------
- (void)willShowOnNav {
    [self.navigationController.navigationBar addSubview:self.navTitleView];
    [self.navigationController.navigationBar addSubview:self.followButton];
}

//----------------------------------------------------------------------------------------------------
- (void)requiresFullScreenMode {
    
}
@end
