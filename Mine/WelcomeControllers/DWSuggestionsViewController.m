//
//  DWSuggestionsViewController.m
//  Mine
//
//  Created by Deepak Rao on 8/15/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWSuggestionsViewController.h"
#import "DWNavigationBarBackButton.h"
#import "DWNavigationBarTitleView.h"
#import "DWSuggestion.h"
#import "DWConstants.h"


/**
 * Total number of suggestions
 */
static NSInteger const kTotalSuggestions        = 4;
static NSString* const kMessageTitle            = @"Pick a great item you bought recently:";
static NSString* const kMessageSubtitle         = @"You'll choose how you share it.";


@interface DWSuggestionsViewController () {
    NSMutableArray              *_imageButtons;
    NSMutableArray              *_titleLabels;    
    
    DWSuggestionsController     *_suggestionsController;
    DWNavigationBarTitleView    *_navTitleView;
}

/**
 * Suggestion image buttons
 */
@property (nonatomic,strong) NSMutableArray *imageButtons;

/**
 * Suggestion title labels
 */
@property (nonatomic,strong) NSMutableArray *titleLabels;

/**
 * Data controller for the suggestion model
 */
@property (nonatomic,strong) DWSuggestionsController *suggestionsController;

/**
 * Tile view inserted onto the navigation bar.
 */
@property (nonatomic,strong) DWNavigationBarTitleView *navTitleView;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWSuggestionsViewController

@synthesize imageButtons                = _imageButtons;
@synthesize titleLabels                 = _titleLabels;
@synthesize suggestionsController       = _suggestionsController;
@synthesize navTitleView                = _navTitleView;
@synthesize delegate                    = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if (self) {        
        
        self.suggestionsController = [[DWSuggestionsController alloc] init];
        self.suggestionsController.delegate = self;

        self.imageButtons   = [NSMutableArray arrayWithCapacity:kTotalSuggestions];
        self.titleLabels    = [NSMutableArray arrayWithCapacity:kTotalSuggestions];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(suggestionImageLoaded:) 
                                                     name:kNImgSuggestionLoaded
                                                   object:nil];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem   = [DWNavigationBarBackButton backButtonForNavigationController:self.navigationController];
    self.navigationItem.title               = @"";
    
    if(!self.navTitleView)
        self.navTitleView = [DWNavigationBarTitleView logoTitleView];

    [self createMessageBox];
    [self createSuggestionImageButtons];
    [self createSuggestionTitleLabels];
    
    [self.suggestionsController getSuggestions];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Sub view creation

//----------------------------------------------------------------------------------------------------
- (void)createMessageBox {
    
    UIImageView *messageDrawer  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 66)];
    messageDrawer.image         = [UIImage imageNamed:kImgMessageDrawer];
    
    [self.view addSubview:messageDrawer];
    
    
    UILabel *titleLabel                     = [[UILabel alloc] initWithFrame:CGRectMake(0, 13, 320, 18)];
    titleLabel.backgroundColor              = [UIColor clearColor];
    titleLabel.shadowColor                  = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.48];
    titleLabel.shadowOffset                 = CGSizeMake(0,1);    
    titleLabel.textColor                    = [UIColor whiteColor];
    titleLabel.textAlignment                = UITextAlignmentCenter;
    titleLabel.text                         = kMessageTitle;
    titleLabel.font                         = [UIFont fontWithName:@"HelveticaNeue-Bold" 
                                                              size:14];
    [self.view addSubview:titleLabel];
    
    
    UILabel *subtitleLabel                  = [[UILabel alloc] initWithFrame:CGRectMake(0, 32, 320, 18)];
    subtitleLabel.backgroundColor           = [UIColor clearColor]; 
    subtitleLabel.shadowColor               = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.48];
    subtitleLabel.shadowOffset              = CGSizeMake(0,1);
    subtitleLabel.textColor                 = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];    
    subtitleLabel.textAlignment             = UITextAlignmentCenter;
    subtitleLabel.text                      = kMessageSubtitle;
    subtitleLabel.font                      = [UIFont fontWithName:@"HelveticaNeue" 
                                                              size:14];
    [self.view addSubview:subtitleLabel];
}

//----------------------------------------------------------------------------------------------------
- (void)createSuggestionImageButtons {
    
    for(NSInteger i=0 ; i<kTotalSuggestions/2 ; i++) {                
        for(NSInteger j=0 ; j<kTotalSuggestions/2 ; j++) {
            
            UIButton *imageButton       = [[UIButton alloc] initWithFrame:CGRectMake(160*j, 175*i+66, 160, 175)];
            imageButton.backgroundColor = [UIColor colorWithRed:0.266 green:0.266 blue:0.266 alpha:1.0];
        
            [imageButton addTarget:self
                            action:@selector(didTapImageButton:)
                  forControlEvents:UIControlEventTouchUpInside];
        
            [self.imageButtons addObject:imageButton];        
            [self.view addSubview:imageButton];
        }
    }
}

//----------------------------------------------------------------------------------------------------
- (void)createSuggestionTitleLabels {
    
    for(NSInteger i=0 ; i<kTotalSuggestions/2 ; i++) {                
        for(NSInteger j=0 ; j<kTotalSuggestions/2 ; j++) {
            
            UILabel *titleLabel         = [[UILabel alloc] initWithFrame:CGRectMake(160*j, 175*i+125, 160, 175)];        
            
            titleLabel.backgroundColor  = [UIColor clearColor];
            titleLabel.shadowColor      = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
            titleLabel.shadowOffset     = CGSizeMake(0,1);            
            titleLabel.textColor        = [UIColor whiteColor];            
            titleLabel.textAlignment	= UITextAlignmentCenter;
            titleLabel.font				= [UIFont fontWithName:@"HelveticaNeue-Bold" 
                                                 size:14];	            
        
            [self.titleLabels addObject:titleLabel];        
            [self.view addSubview:titleLabel];
        }
    }
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWSuggestionsControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)suggestionsLoaded:(NSMutableArray *)suggestions {
    
    for(NSInteger i=0 ; i<kTotalSuggestions ; i++) {
        DWSuggestion *suggestion = [suggestions objectAtIndex:i];
        
        UIButton *imageButton = [self.imageButtons objectAtIndex:i];
        imageButton.tag = suggestion.databaseID;
        
        UILabel *titleLabel = [self.titleLabels objectAtIndex:i];
        titleLabel.text = suggestion.title;
        
        [suggestion downloadImage];
        [imageButton setBackgroundImage:suggestion.image 
                               forState:UIControlStateNormal];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)suggestionsLoadError:(NSString *)error {
    
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UI Events

//----------------------------------------------------------------------------------------------------
- (void)didTapImageButton:(UIButton*)button {
    [self.delegate suggestionPicked:button.tag];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)suggestionImageLoaded:(NSNotification*)notification {
    NSDictionary *userInfo  = [notification userInfo];
    NSInteger    resourceID = [[userInfo objectForKey:kKeyResourceID] integerValue];
    
    for(UIButton *imageButton in self.imageButtons) {        
        if(imageButton.tag == resourceID) {            
            [imageButton setBackgroundImage:[userInfo objectForKey:kKeyImage] 
                                   forState:UIControlStateNormal];
            break;
        }
    }
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors

//----------------------------------------------------------------------------------------------------
- (void)willShowOnNav {
    [self.navigationController.navigationBar addSubview:self.navTitleView];
}

@end
