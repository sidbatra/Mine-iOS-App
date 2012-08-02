//
//  DWUsersViewController.m
//  Mine
//
//  Created by Siddharth Batra on 8/2/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWUsersViewController.h"

#import "DWUsersViewDataSource.h"
#import "DWuserPresenter.h"
#import "DWPurchase.h"
#import "DWUser.h"

#import "DWConstants.h"


@interface DWUsersViewController () {
    DWPurchase  *_purchase;
}

/**
 * The purchase whose likers are to be displayed.
 */
@property (nonatomic,strong) DWPurchase *purchase;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUsersViewController


@synthesize purchase = _purchase;

//----------------------------------------------------------------------------------------------------
- (id)initWithPurhcase:(DWPurchase*)purchase {
    self = [super init];
    
    if(self) {        
        
        self.purchase = purchase;
        
        self.tableViewDataSource = [[DWUsersViewDataSource alloc] init];
        ((DWUsersViewDataSource*)self.tableViewDataSource).purchaseID = self.purchase.databaseID;
        
        
        [self addModelPresenterForClass:[DWUser class]
                              withStyle:kDefaultModelPresenter 
                          withPresenter:[DWUserPresenter class]];
        
        
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
    
    [(DWUsersViewDataSource*)self.tableViewDataSource loadUsers];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)userSquareImageLoaded:(NSNotification*)notification {
    NSDictionary *userInfo = [notification userInfo];
    
    [self provideResourceToVisibleCells:[DWUser class] 
                               objectID:[[userInfo objectForKey:kKeyResourceID] integerValue]
                              objectKey:kKeySquareImageURL];
}    

@end
