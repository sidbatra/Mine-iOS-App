//
//  DWImportButton.h
//  Mine
//
//  Created by Siddharth Batra on 11/5/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DWImportButtonDelegate;


@interface DWImportButton : UIView {
    UIButton                    *underlayButton;
    UIActivityIndicatorView     *spinner;
    
    __weak id <NSObject,DWImportButtonDelegate> _delegate;
}

@property (nonatomic,weak) id<DWImportButtonDelegate> delegate;

- (void)enterAddState;
- (void)enterCreateState;
- (void)enterLoadingState;

@end



@protocol DWImportButtonDelegate

@required

- (void)importButtonClicked;

@end
