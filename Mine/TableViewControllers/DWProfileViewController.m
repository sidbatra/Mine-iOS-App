//
//  DWProfileViewController.m
//  Mine
//
//  Created by Siddharth Batra on 7/26/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWProfileViewController.h"
#import "DWProfileViewDataSource.h"
#import "DWPurchaseProfilePresenter.h"
#import "DWPaginationPresenter.h"
#import "DWPurchase.h"
#import "DWPagination.h"
#import "DWModelSet.h"
#import "DWUser.h"

#import "DWSession.h"
#import "DWFollowButton.h"
#import "DWConstants.h"

@interface DWProfileViewController() {
    DWFollowButton  *_followButton;
}

@property (nonatomic,strong) DWFollowButton *followButton;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWProfileViewController

@synthesize user            = _user;
@synthesize followButton    = _followButton;
@synthesize delegate        = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)initWithUser:(DWUser*)user {
    self = [super init];
    
    if(self) {        
        
        self.user = user;
        
        self.tableViewDataSource = [[DWProfileViewDataSource alloc] init];
        ((DWProfileViewDataSource*)self.tableViewDataSource).userID = self.user.databaseID;
        
        
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
    
    if(![[DWSession sharedDWSession] isCurrentUser:self.user.databaseID]) {
        
        if(!self.followButton)
            self.followButton = [[DWFollowButton alloc] initWithFrame:CGRectMake(240, 6, 81, 32)];
        
        [(DWProfileViewDataSource*)self.tableViewDataSource loadFollowing];
    }
    
    [(DWProfileViewDataSource*)self.tableViewDataSource loadUser];
    [(DWProfileViewDataSource*)self.tableViewDataSource loadPurchases];
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
    
    if(!purchaseID)
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
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors

//----------------------------------------------------------------------------------------------------
- (void)willShowOnNav {
    [self.navigationController.navigationBar addSubview:self.followButton];
}
@end
