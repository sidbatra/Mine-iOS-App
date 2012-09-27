//
//  DWFollowButtonDelegate.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef enum {
    kFollowButonStyleDark = 0,
    kFollowButonStyleLight = 1,
} DWFollowButtonStyle;



@protocol DWFollowButtonDelegate;

@interface DWFollowButton : UIView {
    UIButton                    *underlayButton;
    UIActivityIndicatorView     *spinner;
        
    __weak id <NSObject,DWFollowButtonDelegate>  _delegate;
}

@property (nonatomic,weak) id<NSObject,DWFollowButtonDelegate> delegate;

- (void)enterActiveState;
- (void)enterInactiveState;
- (void)startSpinning;


- (id)initWithFrame:(CGRect)frame followButtonStyle:(DWFollowButtonStyle)followButtonStyle;

@end



@protocol DWFollowButtonDelegate

@required

- (void)followButtonClicked;

@end
