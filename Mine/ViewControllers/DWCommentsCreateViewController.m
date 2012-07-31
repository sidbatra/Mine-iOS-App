//
//  DWCommentsCreateViewController.m
//  Mine
//
//  Created by Siddharth Batra on 7/30/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWCommentsCreateViewController.h"

#import "DWCommentsViewController.h"
#import "DWPurchase.h"


@interface DWCommentsCreateViewController () {
    DWPurchase *_purchase;
    
    DWCommentsViewController *_commentsViewController;
}

/**
 * The purchase who comments are to be displayed and created.
 */
@property (nonatomic,strong) DWPurchase *purchase;

/**
 * Table view controller for displaying comments.
 */
@property (nonatomic,strong) DWCommentsViewController *commentsViewController;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWCommentsCreateViewController

@synthesize purchase                = _purchase;
@synthesize commentsViewController  = _commentsViewController;
@synthesize commentTextField        = _commentTextField;

//----------------------------------------------------------------------------------------------------
- (id)initWithPurchase:(DWPurchase*)purchase {
    self = [super init];
    
    if (self) {
        self.purchase = purchase;
    }
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(!self.commentsViewController) {
        self.commentsViewController = [[DWCommentsViewController alloc] initWithComments:self.purchase.comments];
        self.commentsViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.commentTextField.frame.size.height);
    }
    
    [self.view addSubview:self.commentsViewController.view];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];

}



@end
