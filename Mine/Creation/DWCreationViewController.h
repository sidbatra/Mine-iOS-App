//
//  DWCreationViewController.h
//  Mine
//
//  Created by Deepak Rao on 8/3/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DWProductsViewController.h"

@interface DWCreationViewController : UIViewController<UITextFieldDelegate,DWProductsViewControllerDelegate> {
    UITextField     *_searchTextField;
    UIImageView     *_productImageView;
}

/**
 * IBOutlet properties
 */
@property (nonatomic) IBOutlet UITextField *searchTextField;
@property (nonatomic) IBOutlet UIImageView *productImageView;

@end
