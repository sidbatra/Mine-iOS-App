//
//  DWCommentsViewDataSource.m
//  Mine
//
//  Created by Siddharth Batra on 7/30/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWCommentsViewDataSource.h"
#import "DWPurchase.h"
#import "DWComment.h"


@interface DWCommentsViewDataSource() {
    DWCommentsController    *_commentsController;
    NSInteger _purchaseID;
    BOOL   _loadRemotely;
}

@property (nonatomic,strong) DWCommentsController *commentsController;
@property (nonatomic,assign) NSInteger purchaseID;
@property (nonatomic,assign) BOOL loadRemotely;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWCommentsViewDataSource

@synthesize commentsController = _commentsController;
@synthesize loadRemotely = _loadRemotely;
@synthesize purchaseID = _purchaseID;


//----------------------------------------------------------------------------------------------------
- (id)initWithPurchaseID:(NSInteger)purchaseID
            loadRemotely:(BOOL)loadRemotely {
    
    self = [super init];
    
    if(self) {
        
        self.purchaseID = purchaseID;
        self.loadRemotely = loadRemotely;
        
        if(self.loadRemotely) {
            self.commentsController = [[DWCommentsController alloc] init];
            self.commentsController.delegate = self;
        }
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)loadComments {
    if(self.loadRemotely) {
        [self.commentsController getCommentsForPurchaseID:self.purchaseID];
    }
    else {
        DWPurchase *purchase = [DWPurchase fetch:self.purchaseID];
        
        for(DWComment *comment in purchase.comments)
            [comment incrementPointerCount];
        
        self.objects = purchase.comments;
        
        [self.delegate reloadTableView];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)refreshInitiated {
    [self loadComments];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWCommentsControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)commentsLoaded:(NSMutableArray *)comments
         forPurchaseID:(NSNumber*)purchaseID {
    
    if([purchaseID integerValue] != self.purchaseID)
        return;

    self.objects = comments;
    
    [self.delegate reloadTableView];
}

//----------------------------------------------------------------------------------------------------
- (void)commentsLoadError:(NSString *)error
            forPurchaseID:(NSNumber *)purchaseID {
    
    if([purchaseID integerValue] != self.purchaseID)
        return;
    
    [self.delegate displayError:error
                  withRefreshUI:YES];
}

@end
