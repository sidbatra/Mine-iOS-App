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
    UITextField *_searchTextField;
}

/**
 * IBOutlet properties
 */
@property (nonatomic) IBOutlet UITextField *searchTextField;

@end
