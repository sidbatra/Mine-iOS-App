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
#import "DWAnalyticsManager.h"
#import "DWConstants.h"


/**
 * Total number of suggestions
 */
static NSInteger const kTotalSuggestions        = 4;
static NSString* const kMessageTitle            = @"Pick a great item you bought recently:";
static NSString* const kMessageSubtitle         = @"You'll choose how you share it.";
static NSString* const kImgSuggestionDivider    = @"suggestion-divider.png";


@interface DWSuggestionsViewController () {
    NSMutableArray              *_imageViews;
    NSMutableArray              *_imageButtons;
    NSMutableArray              *_titleLabels;
    
    DWSuggestionsController     *_suggestionsController;
    DWNavigationBarTitleView    *_navTitleView;
    
    UIView                      *_loadingView;
}

/**
 * Suggestion image views
 */
@property (nonatomic,strong) NSMutableArray *imageViews;

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

/**
 * Loading view with the spinner
 */
@property (nonatomic,strong) UIView *loadingView;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWSuggestionsViewController

@synthesize imageViews                  = _imageViews;
@synthesize imageButtons                = _imageButtons;
@synthesize titleLabels                 = _titleLabels;
@synthesize suggestionsController       = _suggestionsController;
@synthesize navTitleView                = _navTitleView;
@synthesize loadingView                 = _loadingView;
@synthesize delegate                    = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if (self) {        
        
        self.suggestionsController = [[DWSuggestionsController alloc] init];
        self.suggestionsController.delegate = self;

        self.imageViews     = [NSMutableArray arrayWithCapacity:kTotalSuggestions];
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
    
    self.view.backgroundColor = [UIColor colorWithRed:0.2235 green:0.2235 blue:0.2235 alpha:1.0];
    
    if(!self.navTitleView)
        self.navTitleView = [DWNavigationBarTitleView logoTitleView];

    [self createMessageBox];
    [self createDivider];
    [self createSuggestionImageButtons];
    [self createSuggestionTitleLabels];
    [self createLoadingView];
    
    [self.suggestionsController getSuggestions];
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Welcome Create View"];
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
    
    UIView *messageDrawerView               = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 66)];
    messageDrawerView.backgroundColor       = [UIColor colorWithRed:0.2235 green:0.2235 blue:0.2235 alpha:1.0];
    
    [self.view addSubview:messageDrawerView];
    
    
    UILabel *titleLabel                     = [[UILabel alloc] initWithFrame:CGRectMake(0, 13, 320, 18)];
    titleLabel.backgroundColor              = [UIColor clearColor];
    titleLabel.textColor                    = [UIColor whiteColor];
    titleLabel.textAlignment                = UITextAlignmentCenter;
    titleLabel.text                         = kMessageTitle;
    titleLabel.font                         = [UIFont fontWithName:@"HelveticaNeue-Bold" 
                                                              size:14];
    [self.view addSubview:titleLabel];
    
    
    UILabel *subtitleLabel                  = [[UILabel alloc] initWithFrame:CGRectMake(0, 34, 320, 18)];
    subtitleLabel.backgroundColor           = [UIColor clearColor]; 
    subtitleLabel.textColor                 = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];    
    subtitleLabel.textAlignment             = UITextAlignmentCenter;
    subtitleLabel.text                      = kMessageSubtitle;
    subtitleLabel.font                      = [UIFont fontWithName:@"HelveticaNeue" 
                                                              size:14];
    [self.view addSubview:subtitleLabel];
}

//----------------------------------------------------------------------------------------------------
- (void)createDivider {
    UIImageView *dividerImageView           = [[UIImageView alloc] initWithFrame:CGRectMake(11, 44, 298, 326)];
    dividerImageView.image                  = [UIImage imageNamed:kImgSuggestionDivider];
    
    [self.view addSubview:dividerImageView];
}

//----------------------------------------------------------------------------------------------------
- (void)createSuggestionImageButtons {
    
    for(NSInteger i=0 ; i<kTotalSuggestions/2 ; i++) {                
        for(NSInteger j=0 ; j<kTotalSuggestions/2 ; j++) {
            
            UIImageView *imageView       = [[UIImageView alloc] initWithFrame:CGRectMake(160*j+35, 175*i+75, 90, 90)];
            imageView.backgroundColor    = [UIColor clearColor];
            
            [self.imageViews addObject:imageView];
            [self.view addSubview:imageView];
            
            
            UIButton *imageButton       = [[UIButton alloc] initWithFrame:CGRectMake(160*j, 175*i+66, 160, 175)];
            imageButton.backgroundColor = [UIColor clearColor];
        
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
            
            UILabel *titleLabel         = [[UILabel alloc] initWithFrame:CGRectMake(160*j, 175*i+92, 160, 175)];
            
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
- (void)createLoadingView {
    
    self.loadingView                        = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
    self.loadingView.backgroundColor        = [UIColor colorWithRed:0.2235 green:0.2235 blue:0.2235 alpha:1.0];
    
    UIActivityIndicatorView *spinnerView    = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    spinnerView.frame                       = CGRectMake(150, 198, 20, 20);
    [spinnerView startAnimating];
    
    [self.loadingView addSubview:spinnerView];
    
    [self.view addSubview:self.loadingView];
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
        
        UIImageView *imageView = [self.imageViews objectAtIndex:i];
        imageView.tag = suggestion.databaseID;
        
        UILabel *titleLabel = [self.titleLabels objectAtIndex:i];
        titleLabel.text = suggestion.title;
        
        [suggestion downloadImage];
        imageView.image = suggestion.image;
    }
    
    self.loadingView.hidden = YES;
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
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Suggestion Card Clicked"];    
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)suggestionImageLoaded:(NSNotification*)notification {
    NSDictionary *userInfo  = [notification userInfo];
    NSInteger    resourceID = [[userInfo objectForKey:kKeyResourceID] integerValue];
    
    for(UIImageView *imageView in self.imageViews) {
        if(imageView.tag == resourceID) {
            imageView.image = [userInfo objectForKey:kKeyImage];
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
    
    if(self.navigationController.navigationBarHidden)
        [self.navigationController setNavigationBarHidden:NO
                                                 animated:YES];
    
    [self.navigationController.navigationBar addSubview:self.navTitleView];
}

@end
