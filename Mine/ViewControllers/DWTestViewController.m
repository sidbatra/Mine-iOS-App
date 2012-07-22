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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.usersController = [[DWUsersController alloc] init];
        self.usersController.delegate = self;
        
        
        
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
    
    [self.usersController getUserWithID:1];
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (NSInteger)userResourceID {
    return 1;
}

- (void)userLoaded:(DWUser*)user {
    NSLog(@"%@ %@ %@ %@ %@  %@ %@  %d",user.firstName,user.lastName,user.gender,user.handle,user.byline,user.squareImageURL,user.largeImageURL,user.purchasesCount);
    [user downloadSquareImage];
    
    //UIImage *image = [user squareImage];
    //NSLog(@"SIZE - %f %f",image.size.width,image.size.height);
}


- (void)squareImageLoaded:(NSNotification*)notification {
    NSDictionary *info = [notification userInfo];
    //NSString *url = [info objectForKey:kKeyURL];
    
    DWUser *user = [DWUser fetch:1];
    UIImage *image = [user squareImage];// [info objectForKey:kKeyImage];
    
    NSLog(@"SIZE - %f %f",image.size.width,image.size.height);
}
@end
