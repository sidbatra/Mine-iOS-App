//
//  DWProfileViewController.m
//  Mine
//
//  Created by Siddharth Batra on 7/26/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWProfileViewController.h"
#import "DWProfileViewDataSource.h"
#import "DWPurchaseFeedPresenter.h"
#import "DWPaginationPresenter.h"
#import "DWPurchase.h"
#import "DWPagination.h"
#import "DWModelSet.h"
#import "DWUser.h"
#import "DWConstants.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWProfileViewController

@synthesize user = _user;

//----------------------------------------------------------------------------------------------------
- (id)initWithUser:(DWUser*)user {
    self = [super init];
    
    if(self) {        
        
        self.user = user;
        
        self.tableViewDataSource = [[DWProfileViewDataSource alloc] init];
        ((DWProfileViewDataSource*)self.tableViewDataSource).userID = self.user.databaseID;
        
        
        [self addModelPresenterForClass:[DWModelSet class]
                              withStyle:kDefaultModelPresenter 
                          withPresenter:[DWPurchaseFeedPresenter class]];
        
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
    
    [(DWProfileViewDataSource*)self.tableViewDataSource loadPurchases];
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
@end
