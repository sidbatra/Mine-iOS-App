//
//  DWInvitePeopleViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>

#import "DWContactsViewController.h"

@class DWNavTitleView;
@class DWNavBarRightButtonView;
@class DWSpinnerOverlayView;

@protocol DWInviteViewControllerDelegate;

/**
 * View for adding people throughout the app.
 */
@interface DWInviteViewController : UIViewController<UITextFieldDelegate,DWContactsViewControllerDelegate> {
    UITextField                 *_searchContactsTextField;
    UIImageView                 *_topShadowView;
    UILabel                     *_messageLabel;
    UIView                      *_spinnerContainerView;            
    
    NSString                    *_navBarTitle;
    NSString                    *_navBarSubTitle;    
    NSString                    *_inviteAlertText;  
    NSString                    *_messageLabelText;
    NSInteger                   _teamID;    
    BOOL                        _enforceInvite;
    BOOL                        _teamSpecificInvite;      
    BOOL                        _showTopShadow;
    BOOL                        _showBackButton;
    BOOL                        _showCancelButton;
    BOOL                        _addBackgroundView;
        
    DWNavTitleView              *_navTitleView;
    DWNavBarRightButtonView     *_navBarRightButtonView;
    DWSpinnerOverlayView        *_spinnerOverlayView;    
    
    DWContactsViewController    *_queryContactsViewController;
    DWContactsViewController    *_addedContactsViewController;    
        
    __weak id <DWInviteViewControllerDelegate> _delegate;
}

/**
 * IBOutlet properties
 */
@property (nonatomic) IBOutlet UITextField *searchContactsTextField;
@property (nonatomic) IBOutlet UIImageView *topShadowView;
@property (nonatomic) IBOutlet UILabel *messageLabel;
@property (nonatomic) UIView *spinnerContainerView;

///**
// * Titles for navigation bar
// */
//@property (nonatomic,copy) NSString *navBarTitle;
//@property (nonatomic,copy) NSString *navBarSubTitle;
//
///**
// * Text to show in the invite alert message
// */
//@property (nonatomic,copy) NSString *inviteAlertText;
//
///**
// * Text to show in the message label
// */
//@property (nonatomic,copy) NSString *messageLabelText;
//
///**
// * ID for the team which the user is inviting. 0 by default
// */
//@property (nonatomic,assign) NSInteger teamID;
//
///**
// * Property to enforce invite. YES by default.
// */
//@property (nonatomic,assign) BOOL enforceInvite;
//
///**
// * Property that checks whether the invites are for a 
// * specific team. YES by default.
// */
//@property (nonatomic,assign) BOOL teamSpecificInvite;
//
///**
// * Property to show its own nav bar shadow. NO by default.
// */
//@property (nonatomic,assign) BOOL showTopShadow;
//
///**
// * Property to show nav bar back button. NO by default.
// */
//@property (nonatomic,assign) BOOL showBackButton;
//
///**
// * Property to show nav bar close button. NO by default.
// */
//@property (nonatomic,assign) BOOL showCancelButton;
//
///**
// * Property to add its own background view. No by default.
// */
//@property (nonatomic,assign) BOOL addBackgroundView;
//
///**
// * Custom subviews for navigation bar
// */
//@property (nonatomic,strong) DWNavTitleView *navTitleView;
//@property (nonatomic,strong) DWNavBarRightButtonView *navBarRightButtonView;
//
///**
// * Custom overlay spinner view
// */
//@property (nonatomic,strong) DWSpinnerOverlayView *spinnerOverlayView; 

/**
 * Controllers for quering and added contacts from the address book
 */
@property (nonatomic,strong) DWContactsViewController *queryContactsViewController;
@property (nonatomic,strong) DWContactsViewController *addedContactsViewController;

/**
 * Delegate to send updates to
 */
@property (nonatomic,weak) id<DWInviteViewControllerDelegate> delegate;


/**
 * IBActions
 */
- (IBAction)searchContactsTextFieldEditingChanged:(id)sender;

@end


/**
 * Delegate protocol to receive events during 
 * the add people view lifecycle
 */
@protocol DWInviteViewControllerDelegate

@optional

/*
 * Fired when the user decides to skip invite
 */
- (void)inviteSkipped;

/*
 * Fired when people are invited to use the app.
 */
- (void)peopleInvited;

@end