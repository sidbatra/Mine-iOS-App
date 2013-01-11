//
//  DWShareProfileViewController.h
//  Mine
//
//  Created by Siddharth Batra on 1/7/13.
//  Copyright (c) 2013 Denwen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DWShareProfileViewControllerDelegate;


@interface DWShareProfileViewController : UIViewController {
    UIButton *_facebookButton;
    UIButton *_twitterButton;
    
    UILabel *_mainMessageLabel;
    UILabel *_bottomMessageLabel;
    
    BOOL _isOnboarding;
    
    __weak id <DWShareProfileViewControllerDelegate> _delegate;
}

@property (nonatomic,weak) id<DWShareProfileViewControllerDelegate> delegate;

@property (nonatomic) IBOutlet UIButton *facebookButton;
@property (nonatomic) IBOutlet UIButton *twitterButton;
@property (nonatomic) IBOutlet UILabel *mainMessageLabel;
@property (nonatomic) IBOutlet UILabel *bottomMessageLabel;

@property (nonatomic,assign) BOOL isOnboarding;

@property (nonatomic,readonly) BOOL isFacebookConnectAvailable;
@property (nonatomic,readonly) BOOL isTwitterConnectAvailable;
@property (nonatomic,readonly) BOOL isAnyConnectAvailable;

@end



@protocol DWShareProfileViewControllerDelegate

@required

- (void)shareProfileViewControllerFinished;

@end