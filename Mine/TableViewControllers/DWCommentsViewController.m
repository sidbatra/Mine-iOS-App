//
//  DWCommentsViewController.m
//  Mine
//
//  Created by Siddharth Batra on 7/30/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWCommentsViewController.h"

#import "DWCommentsViewDataSource.h"
#import "DWCommentPresenter.h"
#import "DWPurchase.h"
#import "DWUser.h"
#import "DWComment.h"
#import "DWConstants.h"

@interface DWCommentsViewController () {
}


@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWCommentsViewController

@synthesize delegate = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)initWithPurchaseID:(NSInteger)purchaseID
            loadRemotely:(BOOL)loadRemotely {
    
    self = [super init];
    
    if(self) {        
                
        self.tableViewDataSource = [[DWCommentsViewDataSource alloc] initWithPurchaseID:purchaseID
                                                                           loadRemotely:loadRemotely];
        
        [self addModelPresenterForClass:[DWComment class]
                              withStyle:kDefaultModelPresenter 
                          withPresenter:[DWCommentPresenter class]];
        
        
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
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark View lifecycle

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
    
    [self disablePullToRefresh];
        
    [(DWCommentsViewDataSource*)self.tableViewDataSource loadComments];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Comment helpers

//----------------------------------------------------------------------------------------------------
- (void)newCommentAdded{
    [self reloadTableView];
    [self scrollToBottomWithAnimation:YES];
}

//----------------------------------------------------------------------------------------------------
- (void)newCommentFailed {
    [self reloadTableView];    
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWCommentCellDelegate

//----------------------------------------------------------------------------------------------------
- (void)userClickedForCommentID:(NSNumber*)commentID {
    DWComment *comment = [DWComment fetch:[commentID integerValue]];

    if(!comment)
        return;

    [self.delegate commentsViewUserClicked:comment.user];
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
