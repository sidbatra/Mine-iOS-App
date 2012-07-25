//
//  DWTestViewController.m
//  Mine
//
//  Created by Siddharth Batra on 7/21/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWTestViewController.h"
#import "DWRequestManager.h"
#import "DWImageManager.h"
#import "DWPurchase.h"
#import "DWSession.h"
#import "DWConstants.h"

@interface DWTestViewController ()

@end

@implementation DWTestViewController

@synthesize usersController = _usersController;
@synthesize feedController = _feedController;
@synthesize facebookConnect = _facebookConnect;
@synthesize feedViewController = _feedViewController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.usersController = [[DWUsersController alloc] init];
        self.usersController.delegate = self;
        
        //self.feedController = [[DWFeedController alloc] init];
        //self.feedController.delegate = self;
        
        self.facebookConnect = [[DWFacebookConnect alloc] init];
        self.facebookConnect.delegate = self;

        self.feedViewController = [[DWFeedViewController alloc] init];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(squareImageLoaded:) 
													 name:kNImgUserSquareLoaded
												   object:nil];
    }
    return self;
}

- (void)dealloc {    
    NSLog(@"Test View Controller Released");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self.facebookConnect authorize];

    //self.feedViewController.view.frame = self.view.frame;// CGRectMake(0, 50, self.view.frame.size.width, 100);
    //[self.view addSubview:self.feedViewController.tableView];
    
    [self.usersController getUserWithID:1];
    //[self.feedController getPurchasesBefore:0];
    //[self.feedController getPurchasesBefore:1339021725];
}


- (NSInteger)userResourceID {
    return 1;
}

- (void)userLoaded:(DWUser*)user {
    [user debug];
    [user downloadSquareImage];
}

- (void)userLoadError:(NSString*)error {
    NSLog(@"ERROR LOADING USER - %@",error);
}

- (void)userCreated:(DWUser*)user {
    [user debug];
    [[DWSession sharedDWSession] create:user];
}

- (void)userCreationError:(NSString*)error {
    NSLog(@"Error creating user");
}


- (void)squareImageLoaded:(NSNotification*)notification {
    //NSDictionary *info = [notification userInfo];
    //NSString *url = [info objectForKey:kKeyURL];
    //UIImage *image = [info objectForKey:kKeyImage];
    
    DWUser *user = [DWUser fetch:1];
    UIImage *image = user.squareImage;
    
    NSLog(@"SIZE - %f %f",image.size.width,image.size.height);
}


- (void)feedLoaded:(NSMutableArray *)purchases {
    NSLog(@"PURCHASES LOADED - %d",[purchases count]);
    
    //for(DWPurchase *purchase in purchases) {
    //    [purchase debug];
    //}
    
    //DWPurchase *first = [purchases objectAtIndex:0];
    //[first debug];
    
    //NSLog(@"TIME - %d",(NSInteger)[first.createdAt timeIntervalSince1970]);
    //NSLog(@"TIME - %ld",);
}

- (void)feedLoadError:(NSString *)error {
    NSLog(@"ERROR LOADING PURACHES _ %@",error);
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWFacebookConnectDelegate

//----------------------------------------------------------------------------------------------------
- (void)fbAuthenticatedWithToken:(NSString *)accessToken {
    NSLog(@"facebook authenticated");
    [self.usersController createUserFromFacebookWithAccessToken:accessToken];
}

//----------------------------------------------------------------------------------------------------
- (void)fbAuthenticationFailed {    
    NSLog(@"facebook authentication failed");
}

@end
