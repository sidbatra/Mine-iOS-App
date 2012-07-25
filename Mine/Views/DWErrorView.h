//
//  DWErrorView.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DWErrorViewProtocol.h"

@protocol DWErrorViewDelegate;

/**
 * Generic view for displaying error messages
 */
@interface DWErrorView : UIView<DWErrorViewProtocol> {
    UILabel         *messageLabel;
    UILabel         *refreshLabel;
    
    UIButton        *viewButton;
    
    UIImageView     *refreshImageView;
    
    __weak id<NSObject,DWErrorViewDelegate>    _delegate;
}

/**
 * Protocol less delegate allowing error view to
 * be easily interchaged throughout the app
 */
@property (nonatomic,weak) id<NSObject,DWErrorViewDelegate> delegate;

@end


/**
 * Protocol for delegates of DWErrorView
 */
@protocol DWErrorViewDelegate

@optional

/**
 * Fired when the user touches anywhere on the error view.
 */
- (void)errorViewTouched;


@end
