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
#import "DWConstants.h"

@interface DWTestViewController ()

@end

@implementation DWTestViewController

@synthesize usersController = _usersController;
@synthesize feedController = _feedController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.usersController = [[DWUsersController alloc] init];
        self.usersController.delegate = self;
        
        self.feedController = [[DWFeedController alloc] init];
        self.feedController.delegate = self;
        
        
        
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
    
    NSLog(@"Test View Controller Loaded");
    
    //[self.usersController getUserWithID:1];
    [self.feedController getPurchasesBefore:0];
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


- (void)squareImageLoaded:(NSNotification*)notification {
    NSDictionary *info = [notification userInfo];
    //NSString *url = [info objectForKey:kKeyURL];
    UIImage *image = [info objectForKey:kKeyImage];
    
    //DWUser *user = [DWUser fetch:1];
    //UIImage *image = [user squareImage];
    
    NSLog(@"SIZE - %f %f",image.size.width,image.size.height);
}


- (void)feedLoaded:(NSMutableArray *)purchases {
    NSLog(@"PURCHASES LOADED - %d",[purchases count]);
}

- (void)feedLoadError:(NSString *)error {
    NSLog(@"ERROR LOADING PURACHES _ %@",error);
}

@end
