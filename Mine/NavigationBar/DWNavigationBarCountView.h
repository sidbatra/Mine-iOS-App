//
//  DWNavigationBarCountView.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DWNavigationBarCountViewDelegate;


@interface DWNavigationBarCountView : UIView {
    UIButton    *backgroundButton;
    UILabel     *countLabel;
    
    __weak id<DWNavigationBarCountViewDelegate> _delegate;
}

@property (nonatomic,weak) id<DWNavigationBarCountViewDelegate> delegate;


- (void)setCount:(NSInteger)count;

@end



@protocol DWNavigationBarCountViewDelegate

- (void)countButtonClicked;

@end