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
- (id)initWithComments:(NSMutableArray*)comments {
    self = [super init];
    
    if(self) {        
                
        self.tableViewDataSource = [[DWCommentsViewDataSource alloc] init];
        
        for(DWComment *comment in comments)
            [comment incrementPointerCount];
        
        self.tableViewDataSource.objects = comments;
        
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
    
    [self reloadTableView];
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
