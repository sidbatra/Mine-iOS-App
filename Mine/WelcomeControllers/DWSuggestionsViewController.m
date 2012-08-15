//
//  DWSuggestionsViewController.m
//  Mine
//
//  Created by Deepak Rao on 8/15/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWSuggestionsViewController.h"
#import "DWSuggestion.h"
#import "DWConstants.h"


/**
 * Total number of suggestions
 */
static NSInteger const kTotalSuggestions = 4;


@interface DWSuggestionsViewController () {
    NSMutableArray          *_imageButtons;
    NSMutableArray          *_titleLabels;    
    
    DWSuggestionsController *_suggestionsController;
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

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWSuggestionsViewController

@synthesize imageButtons                = _imageButtons;
@synthesize titleLabels                 = _titleLabels;
@synthesize suggestionsController       = _suggestionsController;
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
- (void)createSuggestionImageButtons {
    
    for(NSInteger i=0 ; i<kTotalSuggestions ; i++) {
        UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(70*i + 10, 40, 60, 60)];
        
        imageButton.imageView.contentMode   = UIViewContentModeScaleAspectFit;
        imageButton.backgroundColor         = [UIColor yellowColor];
        
        [imageButton addTarget:self
                        action:@selector(didTapImageButton:)
              forControlEvents:UIControlEventTouchUpInside];
        
        [self.imageButtons addObject:imageButton];        
        [self.view addSubview:imageButton];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)createSuggestionTitleLabels {
    
    for(NSInteger i=0 ; i<kTotalSuggestions ; i++) {        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70*i + 10, 120, 60, 80)];
        
        titleLabel.font				= [UIFont fontWithName:@"HelveticaNeue" size:13];	
        titleLabel.textColor        = [UIColor blueColor];
        titleLabel.textAlignment	= UITextAlignmentLeft;
        titleLabel.numberOfLines    = 0;
        
        [self.titleLabels addObject:titleLabel];        
        [self.view addSubview:titleLabel];
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
        [imageButton setImage:suggestion.image 
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
            [imageButton setImage:[userInfo objectForKey:kKeyImage] 
                         forState:UIControlStateNormal];
            break;
        }
    }
}

@end
