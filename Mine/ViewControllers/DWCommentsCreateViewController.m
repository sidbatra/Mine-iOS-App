//
//  DWCommentsCreateViewController.m
//  Mine
//
//  Created by Siddharth Batra on 7/30/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWCommentsCreateViewController.h"

#import "DWCommentsViewController.h"
#import "DWSession.h"

#import "DWPurchase.h"
#import "DWConstants.h"


static NSInteger const kBottomBarMargin = 49;


@interface DWCommentsCreateViewController () {
    DWPurchase              *_purchase;
    DWCommentsController    *_commentsController;
    
    BOOL                    _creationIntent;
    NSString                *_lastCommentMessage;
    
    DWCommentsViewController *_commentsViewController;
    
    BOOL    _isKeyboardShown;
}

/**
 * The purchase who comments are to be displayed and created.
 */
@property (nonatomic,strong) DWPurchase *purchase;

/**
 * Comments data controller.
 */
@property (nonatomic,strong) DWCommentsController *commentsController;

/**
 * Whether the view was opened with creation intent
 */
@property (nonatomic,assign) BOOL creationIntent;
/**
 * Text of the last comment created.
 */
@property (nonatomic,copy) NSString *lastCommentMessage;

/**
 * Table view controller for displaying comments.
 */
@property (nonatomic,strong) DWCommentsViewController *commentsViewController;

/**
 * Marks presence of the keyboard on the screen.
 */
@property (nonatomic,assign) BOOL isKeyboardShown;


/**
 * Create am optimistic comment with the given message.
 */
- (void)createCommentWithMessage:(NSString*)message;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWCommentsCreateViewController

@synthesize purchase                = _purchase;
@synthesize commentsController      = _commentsController;
@synthesize creationIntent          = _creationIntent;
@synthesize lastCommentMessage      = _lastCommentMessage;
@synthesize commentsViewController  = _commentsViewController;
@synthesize isKeyboardShown         = _isKeyboardShown;
@synthesize commentTextField        = _commentTextField;

//----------------------------------------------------------------------------------------------------
- (id)initWithPurchase:(DWPurchase*)purchase 
    withCreationIntent:(BOOL)creationIntent {
    
    self = [super init];
    
    if (self) {
        self.purchase       = purchase;
        self.creationIntent = creationIntent;
        
        self.commentsController = [[DWCommentsController alloc] init];
        self.commentsController.delegate = self;
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillShow:) 
                                                 name:UIKeyboardWillShowNotification 
                                               object:self.view.window];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillHide:) 
                                                 name:UIKeyboardWillHideNotification 
                                               object:self.view.window];
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//----------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark View lifecycle

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(!self.commentsViewController) {
        self.commentsViewController = [[DWCommentsViewController alloc] initWithComments:self.purchase.comments];
        self.commentsViewController.view.frame = CGRectMake(0,
                                                            0, 
                                                            self.view.frame.size.width, 
                                                            self.view.frame.size.height - self.commentTextField.frame.size.height);
        
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(commentsViewControllerTapped)];
        gestureRecognizer.cancelsTouchesInView = NO;
        [self.commentsViewController.view addGestureRecognizer:gestureRecognizer];        
    }
    
    [self.view insertSubview:self.commentsViewController.view
                belowSubview:self.commentTextField];
}

//----------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated {
    [self.commentsViewController scrollToBottomWithAnimation:NO];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidAppear:(BOOL)animated {
    if(self.creationIntent) {
        [self.commentTextField becomeFirstResponder];    
        [self.commentsViewController scrollToBottomWithAnimation:NO];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];

}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Comment creation

//----------------------------------------------------------------------------------------------------
- (void)createCommentWithMessage:(NSString*)message {
    self.commentTextField.text = @"";

    self.lastCommentMessage = message;
    
    [self.purchase addTempCommentByUser:[DWSession sharedDWSession].currentUser
                            withMessage:message];
    
    [self.commentsViewController newCommentAdded];
    
    [self.commentsController createCommentForPurchaseID:self.purchase.databaseID
                                            withMessage:message];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWCommentsControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)commentCreated:(DWComment *)comment 
         forPurchaseID:(NSNumber *)purchaseID {
    
    DWPurchase *purchase = [DWPurchase fetch:[purchaseID integerValue]];
    
    if(!purchase)
        return;
    
    [purchase replaceTempCommentWithMountedComment:comment];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNCommentAddedForPurchase
                                                        object:nil
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:purchase,kKeyPurchase,nil]];
}

//----------------------------------------------------------------------------------------------------
- (void)commentCreateError:(NSString *)error 
             forPurchaseID:(NSNumber *)purchaseID {
    
    DWPurchase *purchase = [DWPurchase fetch:[purchaseID integerValue]];
    
    if(!purchase)
        return;
    
    
    [purchase removeTempCommentWithMessage:self.lastCommentMessage];
    
    [self.commentsViewController newCommentFailed];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UI events

//----------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if(textField.text.length) {
        [self createCommentWithMessage:textField.text];
        [textField resignFirstResponder];
    }
    
    return NO;
}

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UITapGestureRecognizer

//----------------------------------------------------------------------------------------------------
- (void)commentsViewControllerTapped {
    [self.commentTextField resignFirstResponder];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications


//----------------------------------------------------------------------------------------------------
- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    
    
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    
    
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    CGRect textFieldFrame = self.commentTextField.frame;
    textFieldFrame.origin.y += keyboardSize.height - kBottomBarMargin;
    
    
    CGRect tableViewFrame = self.commentsViewController.view.frame;
    tableViewFrame.size.height += (keyboardSize.height - kBottomBarMargin);
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
        [self.commentsViewController.view setFrame:tableViewFrame];
        [self.commentTextField setFrame:textFieldFrame];
    
    [UIView commitAnimations];
    
    
    self.isKeyboardShown = NO;
}

//----------------------------------------------------------------------------------------------------
- (void)keyboardWillShow:(NSNotification *)notification {
    
    if (self.isKeyboardShown)
        return;
    
    
    NSDictionary* userInfo = [notification userInfo];
    
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    CGRect textFieldFrame = self.commentTextField.frame;
    textFieldFrame.origin.y -= keyboardSize.height - kBottomBarMargin;
    
    
    CGRect tableViewFrame = self.commentsViewController.view.frame;
    tableViewFrame.size.height -= (keyboardSize.height - kBottomBarMargin);
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
        [self.commentsViewController.view setFrame:tableViewFrame];
        [self.commentTextField setFrame:textFieldFrame];
    
    [UIView commitAnimations];
    
    
    self.isKeyboardShown = YES;
}

@end