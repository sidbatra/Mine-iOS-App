//
//  DWFollowButtonDelegate.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DWFollowButtonDelegate;

@interface DWFollowButton : UIView {
    UIButton                    *underlayButton;
    UIActivityIndicatorView     *spinner;
    
    __weak id <NSObject,DWFollowButtonDelegate>  _delegate;
}

- (void)enterActiveState;
- (void)enterInactiveState;
- (void)startSpinning;


@property (nonatomic,weak) id<NSObject,DWFollowButtonDelegate> delegate;

@end



@protocol DWFollowButtonDelegate

@required

- (void)followButtonClicked;

@end
